import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import { Layout } from "./components/Layout/Layout"
import {
  ApolloClient,
  createHttpLink,
  InMemoryCache,
  ApolloProvider
} from "@apollo/client";

export const link = createHttpLink({
  uri: "http://localhost:8081/query"
});

export const client = new ApolloClient({
  cache: new InMemoryCache(),
  link,
});


const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <React.StrictMode>
    <ApolloProvider client={client}>
      <App />
    </ApolloProvider>
  </React.StrictMode>
);
