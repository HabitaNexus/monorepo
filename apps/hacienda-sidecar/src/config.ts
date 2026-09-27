export const DEFAULT_GRPC_PORT = 50051;

const ENVIRONMENTS = ["sandbox", "production"] as const;
const ID_TYPES = ["01", "02", "03", "04"] as const;

export type HaciendaEnvironment = (typeof ENVIRONMENTS)[number];
export type HaciendaIdType = (typeof ID_TYPES)[number];

export type SidecarConfig = {
  environment: HaciendaEnvironment;
  idType: HaciendaIdType;
  idNumber: string;
  password: string;
};

export class CredentialConfigError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "CredentialConfigError";
  }
}

export function loadCredentials(env: NodeJS.ProcessEnv): SidecarConfig {
  const environment = parseEnvironment(env.HACIENDA_ENVIRONMENT);
  const idType = parseIdType(env.HACIENDA_ID_TYPE);
  const idNumber = requiredText(env.HACIENDA_ID_NUMBER, "HACIENDA_ID_NUMBER");
  const password = requiredText(env.HACIENDA_PASSWORD, "HACIENDA_PASSWORD");
  return { environment, idType, idNumber, password };
}

export function sanitizeStartupError(message: string, env: NodeJS.ProcessEnv): string {
  let sanitized = message;
  for (const key of ["HACIENDA_PASSWORD", "HACIENDA_ID_NUMBER"] as const) {
    const value = env[key];
    if (value) {
      sanitized = sanitized.split(value).join("[redacted]");
    }
  }
  return sanitized;
}

function parseEnvironment(value: string | undefined): HaciendaEnvironment {
  if (value === "sandbox" || value === "production") {
    return value;
  }
  throw new CredentialConfigError("HACIENDA_ENVIRONMENT must be sandbox or production");
}

function parseIdType(value: string | undefined): HaciendaIdType {
  if (value === "01" || value === "02" || value === "03" || value === "04") {
    return value;
  }
  throw new CredentialConfigError("HACIENDA_ID_TYPE must be 01, 02, 03, or 04");
}

function requiredText(value: string | undefined, name: string): string {
  if (!value || value.trim() === "") {
    throw new CredentialConfigError(`${name} is required`);
  }
  return value;
}
