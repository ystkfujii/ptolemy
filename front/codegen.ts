
import type { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  overwrite: true,
  schema: 'http://localhost:8081/query',
  documents: ['src/**/*.tsx', 'src/**/*.ts'],
  generates: {
    "src/__generated__/gql/": {
      preset: "client",
      plugins: [],
      presetConfig: {
        gqlTagName: 'gql',
      }
    }
  },
  ignoreNoDocuments: true
};

export default config;
