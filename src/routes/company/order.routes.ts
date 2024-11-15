import { Router } from 'express';
import { OrderController } from '../../controllers/company/order.controller';
import { ensurePagination } from '../../middlewares/pagination.middleware';

const orderRouter = Router();
const orderController = new OrderController();

orderRouter.get('/:companyId', [ensurePagination], orderController.getCompanyOrders);
orderRouter.get('/:orderId/items', [ensurePagination], orderController.getOrderItems);

export { orderRouter };