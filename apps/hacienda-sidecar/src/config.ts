// ---------------------------------------------------------------------------
// Configuration — distinguish issued IDP usernames from legacy taxpayer IDs
// ---------------------------------------------------------------------------

export type HaciendaEnvironment = "sandbox" | "production";
export type HaciendaIdType = "01" | "02" | "03" | "04";

export type SidecarConfig = {
  environment: HaciendaEnvironment;
  password: string;
} & (
  | { username: string; idType?: never; idNumber?: never }
  | { username?: undefined; idType: HaciendaIdType; idNumber: string }
);

export const DEFAULT_GRPC_PORT = 50051;

// ---------------------------------------------------------------------------
// Public API — fail before listening and keep credential values out of errors
// ---------------------------------------------------------------------------

export class CredentialConfigError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "CredentialConfigError";
  }
}

export function loadCredentials(env: NodeJS.ProcessEnv): SidecarConfig {
  const environment = parseEnvironment(env.HACIENDA_ENVIRONMENT);
  const password = requiredText(env.HACIENDA_PASSWORD, "HACIENDA_PASSWORD");
  if (env.HACIENDA_IDP_USERNAME !== undefined) {
    const username = requiredText(env.HACIENDA_IDP_USERNAME, "HACIENDA_IDP_USERNAME");
    if (/\s/.test(username)) {
      throw new CredentialConfigError("HACIENDA_IDP_USERNAME must not contain whitespace");
    }
    return { environment, username, password };
  }
  const idType = parseIdType(env.HACIENDA_ID_TYPE);
  const idNumber = requiredText(env.HACIENDA_ID_NUMBER, "HACIENDA_ID_NUMBER");
  return { environment, idType, idNumber, password };
}

export function sanitizeStartupError(message: string, env: NodeJS.ProcessEnv): string {
  let sanitized = message;
  for (const key of ["HACIENDA_PASSWORD", "HACIENDA_ID_NUMBER", "HACIENDA_IDP_USERNAME"] as const) {
    const value = env[key];
    if (value) {
      sanitized = sanitized.split(value).join("[redacted]");
    }
  }
  return sanitized;
}

// ---------------------------------------------------------------------------
// Parsers — legacy identification remains available when no username is given
// ---------------------------------------------------------------------------

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
