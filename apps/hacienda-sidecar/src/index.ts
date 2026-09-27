import { boot } from "./boot.js";
import { sanitizeStartupError } from "./config.js";

const env = process.env;

boot(env)
  .then((server) => {
    console.log(`hacienda-sidecar listening on ${server.port}`);
    const stop = () => {
      void server.shutdown().finally(() => process.exit(0));
    };
    process.once("SIGTERM", stop);
    process.once("SIGINT", stop);
  })
  .catch((error: unknown) => {
    const message = error instanceof Error ? error.message : "startup failed";
    console.error(sanitizeStartupError(message, env));
    process.exit(1);
  });
