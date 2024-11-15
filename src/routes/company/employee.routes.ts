import { Router } from 'express';
import { CompanyEmployeeController } from '../../controllers/company/employee.controller';
import { ensurePagination } from '../../middlewares/pagination.middleware';

const companyEmployeeRouter = Router();
const companyEmployeeController = new CompanyEmployeeController();

companyEmployeeRouter.get('/:companyId', [ensurePagination], companyEmployeeController.getCompanyEmployeeList);

export { companyEmployeeRouter };