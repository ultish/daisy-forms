import type { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  schema: 'http://localhost:4000/graphql',
  documents: ['app/graphql/**/*.ts'],
  ignoreNoDocuments: true,
  generates: {
    'app/graphql/types/': {
      preset: 'client',
      config: {
        documentMode: 'string',
        // useTypeImports: true, // makes it work with @graphql-typed-document-node/core
      },
      plugins: ['typescript-operations'],
    },
    'schema.graphql': {
      plugins: ['schema-ast'],
      config: {
        includeDirectives: true,
      },
    },
  },
};

export default config;
