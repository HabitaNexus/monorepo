import type { AuthClient } from "./client.js";

export class TokenGateway {
  constructor(private readonly client: AuthClient) {}

  async getAccessToken(): Promise<string> {
    try {
      return await this.client.getAccessToken();
    } catch (refreshError) {
      try {
        await this.client.authenticate();
      } catch {
        throw refreshError;
      }
      return this.client.getAccessToken();
    }
  }
}
