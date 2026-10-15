import {
  Environment,
  HaciendaClient,
  IdType,
  type HaciendaClientOptions,
} from "@dojocoding/hacienda-sdk";
import type { HaciendaEnvironment, HaciendaIdType, SidecarConfig } from "./config.js";

export type AuthClient = {
  authenticate(): Promise<void>;
  getAccessToken(): Promise<string>;
};

// ---------------------------------------------------------------------------
// Client factory — pass issued usernames unchanged to the published SDK
// ---------------------------------------------------------------------------

export function toClientOptions(config: SidecarConfig): HaciendaClientOptions {
  return {
    environment: toEnvironment(config.environment),
    credentials: config.username !== undefined
      ? { username: config.username, password: config.password }
      : {
          idType: toIdType(config.idType),
          idNumber: config.idNumber,
          password: config.password,
        },
  };
}

export function createHaciendaClient(config: SidecarConfig): HaciendaClient {
  return new HaciendaClient(toClientOptions(config));
}

// ---------------------------------------------------------------------------
// Enum mapping — keep runtime configuration independent of SDK enum values
// ---------------------------------------------------------------------------

function toEnvironment(environment: HaciendaEnvironment): Environment {
  switch (environment) {
    case "sandbox":
      return Environment.Sandbox;
    case "production":
      return Environment.Production;
    default: {
      const unexpected: never = environment;
      return unexpected;
    }
  }
}

function toIdType(idType: HaciendaIdType): IdType {
  switch (idType) {
    case "01":
      return IdType.PersonaFisica;
    case "02":
      return IdType.PersonaJuridica;
    case "03":
      return IdType.DIMEX;
    case "04":
      return IdType.NITE;
    default: {
      const unexpected: never = idType;
      return unexpected;
    }
  }
}
