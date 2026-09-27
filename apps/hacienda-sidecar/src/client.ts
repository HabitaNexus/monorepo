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

export function toClientOptions(config: SidecarConfig): HaciendaClientOptions {
  return {
    environment: toEnvironment(config.environment),
    credentials: {
      idType: toIdType(config.idType),
      idNumber: config.idNumber,
      password: config.password,
    },
  };
}

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

export function createHaciendaClient(config: SidecarConfig): HaciendaClient {
  return new HaciendaClient(toClientOptions(config));
}
