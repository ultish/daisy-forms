// needed for Vite + glimmer-apollo, see https://github.com/josemarluedke/glimmer-apollo/issues/97
import 'glimmer-apollo/environment-ember';

import { setClient } from 'glimmer-apollo';
import {
  ApolloClient,
  InMemoryCache,
  split,
  HttpLink,
} from '@apollo/client/core';

import { getMainDefinition } from '@apollo/client/utilities';
import { GraphQLWsLink } from '@apollo/client/link/subscriptions';
import { createClient } from 'graphql-ws';

export default function setupApolloClient(
  context: object,
  authToken: string | undefined = undefined,
): void {
  const headers = {
    Accept: 'text/event-stream',
    Connection: 'keep-alive',
    'Cache-Control': 'no-cache',
    Authorization: '',
  };

  if (authToken) {
    headers.Authorization = `Bearer ${authToken}`;
  }

  // WebSocket connection to the API
  const wsLink = new GraphQLWsLink(
    createClient({
      url: 'ws://localhost:4000/graphql',
    }),
  );

  // HTTP connection to the API
  const httpLink = new HttpLink({
    uri: 'http://localhost:4000/graphql',
  });

  // Cache implementation
  const cache = new InMemoryCache();

  // Split HTTP link and WebSockete link
  const splitLink = split(
    ({ query }) => {
      const definition = getMainDefinition(query);
      return (
        definition.kind === 'OperationDefinition' &&
        definition.operation === 'subscription'
      );
    },
    // sseLink,
    wsLink,
    httpLink,
  );

  // Create the apollo client
  const apolloClient = new ApolloClient({
    link: splitLink,
    cache,
  });

  // Set default apollo client for Glimmer Apollo
  setClient(context, apolloClient);
}
