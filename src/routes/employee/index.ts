import { Router } from 'express';
import { ensurePagination } from '../../middlewares/pagination.middleware';
import { EmployeeController } from '../../controllers/employee/index';

const employeeRouter = Router();
const employeeController = new EmployeeController();

employeeRouter.get('/:orderId', [ensurePagination], employeeController.getEmployeeOrder);
employeeRouter.get('/:employeeId/recharges', employeeController.getEmployeeRecharges);
employeeRouter.put('/document/:documentId', employeeController.updateEmployeeInformation);

export { employeeRouter };
