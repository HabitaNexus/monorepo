import { createHaciendaClient } from "./client.js";
import { loadCredentials } from "./config.js";

const env = process.env;

try {
  const config = loadCredentials(env);
  const client = createHaciendaClient(config);
  await client.authenticate();
  const token = await client.getAccessToken();
  if (!token) {
    console.error("handshake_failed");
    process.exit(1);
  }
} catch (error: unknown) {
  const message = error instanceof Error ? error.message : "handshake_failed";
  if (message.startsWith("HACIENDA_")) {
    console.error("handshake_failed: credentials are not configured");
  } else {
    console.error("handshake_failed");
  }
  process.exit(1);
}

console.log("handshake_ok");
