import { Router } from 'express';
import { CompanyController } from '../../controllers/company';

const companyRouter = Router();
const companyController = new CompanyController();

companyRouter.get('/', companyController.getCompanyList);
companyRouter.get('/:companyId', companyController.getCompany);
companyRouter.patch('/:companyId', companyController.editCompany);

export { companyRouter };