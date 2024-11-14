import '../patch';
import 'dotenv/config';

import cors from 'cors';
import path from 'path';
import express from 'express';

import swaggerUi from 'swagger-ui-express';
import swaggerDocs from './swagger.json';

import { router } from './routes/index.routes';

class Server {
  private server = express();

  constructor() {
    this.server = express();
    this.configureServer();
    this.setSwagger();
    this.setRoutes();

    this.server.listen(process.env.PORT, () => {
      console.log(`Ambiente: ${process.env.ENVIRONMENT}`);
      console.log(`Servidor na porta: ${process.env.PORT}`);
    });
  }

  configureServer() {
    const uploadsPath = path.resolve(__dirname, '..', 'uploads');
    console.log(`Serving static files from: ${uploadsPath}`);
    this.server.use('/uploads', express.static(uploadsPath));

    this.server.use(express.urlencoded({ extended: true }));
    this.server.use(express.json({ limit: '1mb' }));
    this.server.use(
      cors({
        origin: '*',
        exposedHeaders: 'x-total-count',
      })
    );
  }

  setSwagger() {
    this.server.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));
  }

  setRoutes() {
    this.server.use(router);
  }
}

export default Server;
