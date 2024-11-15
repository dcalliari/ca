import { Router } from 'express';
import { ReplacementController } from '../../controllers/card/replacement.controller';

const replacementRouter = Router();

const replacementController = new ReplacementController();

replacementRouter.get('/', replacementController.getReplacementRequestList);
replacementRouter.get('/contact/:mreqId', replacementController.getContactByMseId);
replacementRouter.get('/request/:mreqId', replacementController.getReplacementRequest);
replacementRouter.put('/cancelRequest/:mreqId', replacementController.cancelReplacementRequest);

export { replacementRouter };