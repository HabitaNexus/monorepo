import { createHaciendaClient, type AuthClient } from "./client.js";
import { DEFAULT_GRPC_PORT, loadCredentials, type SidecarConfig } from "./config.js";
import { startServer, type StartedServer } from "./server.js";
import { TokenGateway } from "./token-gateway.js";

export type BootDependencies = {
  createClient?: (config: SidecarConfig) => AuthClient;
  listen?: (options: {
    gateway: TokenGateway;
    environment: SidecarConfig["environment"];
    port: number;
  }) => Promise<StartedServer>;
};

export async function boot(
  env: NodeJS.ProcessEnv,
  dependencies: BootDependencies = {},
): Promise<StartedServer> {
  const config = loadCredentials(env);
  const createClient = dependencies.createClient ?? createHaciendaClient;
  const listen = dependencies.listen ?? startServer;
  const gateway = new TokenGateway(createClient(config));
  const port = parsePort(env.GRPC_PORT);
  return listen({ gateway, environment: config.environment, port });
}

function parsePort(value: string | undefined): number {
  if (value === undefined || value === "") {
    return DEFAULT_GRPC_PORT;
  }
  const port = Number(value);
  if (!Number.isInteger(port) || port <= 0 || port > 65535) {
    throw new Error("GRPC_PORT must be a TCP port");
  }
  return port;
}
