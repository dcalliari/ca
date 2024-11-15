import { Router } from 'express';

import { authMiddleware } from '../middlewares/auth.middleware';
import { statusRouter } from './card/status.routes';
import { replacementRouter } from './card/replacement.routes';
import { companyRouter } from './company';
import { orderRouter } from './company/order.routes';
import { companyEmployeeRouter } from './company/employee.routes';
import { employeeRouter } from './employee';

const router = Router();

const isAuthMiddlewareEnabled = process.env.AUTH_MIDDLEWARE_ENABLED === 'true';

if (isAuthMiddlewareEnabled) {
  router.use(authMiddleware);
}

router.use('/card/status', statusRouter);
router.use('/card/replacement', replacementRouter);

router.use('/company', companyRouter);
router.use('/company/order', orderRouter);
router.use('/company/employee', companyEmployeeRouter);

router.use('/employee', employeeRouter);

export { router };
