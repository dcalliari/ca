import { Router } from 'express';
import { StatusController } from '../../controllers/card/status.controller';

const statusRouter = Router();
const statusController = new StatusController();

statusRouter.get('/unlock/:companyId', statusController.getAllCardsToUnlock); // renomear
statusRouter.put('/update-not-unlock', statusController.updateCardsToUnlock); // renomear

export { statusRouter };
