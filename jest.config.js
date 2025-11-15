// @ts-check

/** @type {import('@jest/types').Config.InitialOptions} */
const jestConfig = {
  displayName: 'pkg-value-object',
  clearMocks: true,
  testEnvironment: 'node',
  setupFiles: ['<rootDir>/jest.setup.js'],
  transform: {
    '^.+\\.(t|j)sx?$': '@swc/jest',
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!**/*.d.ts',
    '!**/node_modules/**',
    '!**/dist/**',
    '!**/src/models/**',
    '!**/src/constants/**',
    '!**/src/config/**',
    '!**/src/structures/**',
  ],
  testMatch: ['**/__tests__/**/*.[jt]s?(x)', '**/?(*.)+(spec|test).[tj]s?(x)'],
  testPathIgnorePatterns: ['/node_modules/', '/dist/'],
};

module.exports = jestConfig;
