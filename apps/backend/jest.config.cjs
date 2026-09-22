module.exports = {
  rootDir: '.',
  roots: ['<rootDir>/src'],
  testEnvironment: 'node',
  transform: {
    '^.+\\.ts$': ['@swc/jest', {
      jsc: {
        parser: { syntax: 'typescript', decorators: true },
        transform: { decoratorMetadata: true, legacyDecorator: true },
        target: 'es2022',
      },
      module: { type: 'commonjs' },
    }],
  },
  testMatch: ['**/*.spec.ts'],
  moduleNameMapper: { '^(.*)\\.js$': '$1' },
  moduleFileExtensions: ['ts', 'js', 'json'],
};
