import tseslint from "typescript-eslint";

export default tseslint.config(
  { ignores: ["dist/**", "dist-test/**", "reports/**", "node_modules/**"] },
  ...tseslint.configs.recommended,
  { files: ["src/**/*.ts"] },
);
