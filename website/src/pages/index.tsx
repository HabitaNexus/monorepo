import React from 'react';
import {Redirect} from '@docusaurus/router';

// Home redirige al índice de docs (contenido del Inicio MkDocs).
export default function Home(): React.JSX.Element {
  return <Redirect to="/docs/" />;
}
