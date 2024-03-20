import * as React from 'react';
import ReactDOM from 'react-dom/client';
import {SubComponent} from './sub-component';

const  App = () => <div>
    <h1>Hello React!</h1>
    <SubComponent name="My Counter for TypeScript"/>
</div>

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <App />
);
