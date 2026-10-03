import * as grpc from "@grpc/grpc-js";
import * as protoLoader from "@grpc/proto-loader";
import path from "node:path";
import { fileURLToPath } from "node:url";
import type { HaciendaEnvironment } from "./config.js";
import type { TokenGateway } from "./token-gateway.js";

const AUTH_ERROR = "authentication_failed";

type AuthStatusResponse = {
  authenticated: boolean;
  environment: string;
};

type AccessTokenResponse = {
  success: boolean;
  accessToken: string;
  error: string;
};

type HealthResponse = {
  status: "SERVING" | "NOT_SERVING";
};

type UnaryCallback<T> = (error: grpc.ServiceError | null, value?: T) => void;

export type ServerOptions = {
  gateway: TokenGateway;
  environment: HaciendaEnvironment;
  port: number;
};

export type StartedServer = {
  port: number;
  shutdown: () => Promise<void>;
};

const protoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "../proto");

const packageDefinition = protoLoader.loadSync(
  [path.join(protoRoot, "hacienda_auth.proto"), path.join(protoRoot, "health.proto")],
  {
    keepCase: false,
    longs: String,
    enums: String,
    defaults: true,
    oneofs: true,
  },
);

const loaded = grpc.loadPackageDefinition(packageDefinition);

const authService = serviceAt(loaded, ["habitanexus", "hacienda", "auth", "v1", "HaciendaAuth"]);
const healthService = serviceAt(loaded, ["grpc", "health", "v1", "Health"]);

export async function startServer(options: ServerOptions): Promise<StartedServer> {
  const server = new grpc.Server();
  server.addService(authService.service, authHandlers(options));
  server.addService(healthService.service, healthHandlers(options.gateway));

  const boundPort = await new Promise<number>((resolve, reject) => {
    server.bindAsync(
      `0.0.0.0:${options.port}`,
      grpc.ServerCredentials.createInsecure(),
      (error, port) => {
        if (error) {
          reject(error);
          return;
        }
        resolve(port);
      },
    );
  });

  return {
    port: boundPort,
    shutdown: () =>
      new Promise((resolve) => {
        server.tryShutdown(() => resolve());
      }),
  };
}

function authHandlers(options: ServerOptions): grpc.UntypedServiceImplementation {
  return {
    GetAuthStatus: (_call: grpc.ServerUnaryCall<unknown, AuthStatusResponse>, callback: UnaryCallback<AuthStatusResponse>) => {
      void options.gateway.getAccessToken().then(
        () => callback(null, { authenticated: true, environment: options.environment }),
        () => callback(null, { authenticated: false, environment: options.environment }),
      );
    },
    GetAccessToken: (_call: grpc.ServerUnaryCall<unknown, AccessTokenResponse>, callback: UnaryCallback<AccessTokenResponse>) => {
      void options.gateway.getAccessToken().then(
        (accessToken) => callback(null, { success: true, accessToken, error: "" }),
        () => callback(null, { success: false, accessToken: "", error: AUTH_ERROR }),
      );
    },
  };
}

function healthHandlers(gateway: TokenGateway): grpc.UntypedServiceImplementation {
  return {
    Check: (_call: grpc.ServerUnaryCall<unknown, HealthResponse>, callback: UnaryCallback<HealthResponse>) => {
      void gateway.getAccessToken().then(
        () => callback(null, { status: "SERVING" }),
        () => callback(null, { status: "NOT_SERVING" }),
      );
    },
    Watch: (call: grpc.ServerWritableStream<unknown, HealthResponse>) => {
      void gateway.getAccessToken().then(
        () => call.write({ status: "SERVING" }),
        () => call.write({ status: "NOT_SERVING" }),
      );
    },
  };
}

function serviceAt(root: grpc.GrpcObject, segments: string[]): grpc.ServiceClientConstructor {
  let current: grpc.GrpcObject | grpc.ServiceClientConstructor | grpc.ProtobufTypeDefinition = root;
  for (const segment of segments) {
    if (!isGrpcObject(current)) {
      throw new Error(`Proto path missing segment ${segment}`);
    }
    const next: grpc.GrpcObject | grpc.ServiceClientConstructor | grpc.ProtobufTypeDefinition | undefined =
      current[segment];
    if (!next) {
      throw new Error(`Proto path missing segment ${segment}`);
    }
    current = next;
  }
  if (typeof current !== "function") {
    throw new Error(`Proto service not found: ${segments.join(".")}`);
  }
  return current;
}

function isGrpcObject(
  value: grpc.GrpcObject | grpc.ServiceClientConstructor | grpc.ProtobufTypeDefinition,
): value is grpc.GrpcObject {
  return typeof value === "object" && value !== null && !("format" in value);
}
