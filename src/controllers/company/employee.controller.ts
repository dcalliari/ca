import { Request, Response } from 'express';
import { Prisma } from '@prisma/client';
import { prisma } from '../../config/database.config';
import { PaginatedResponse, Pagination } from '../../utils/pagination.utils';

type Employee = {
    id: number;
    salCompanyId: number;
    document: string;
    groupname: string;
    name: string;
    birthDate: string;
    hrID: null;
    motherName: string;
    dailyValue: number;
    SalEmployeeGroupId: number;
    cardNumber: null;
    addrZipCode: string;
    addrStreet: string;
    addrNbr: string;
    addrComplement: string;
    addrDistrict: string;
    addrCity: string;
    toSysCode: null;
    externalId: null;
    isActive: boolean;
    blameUser: string;
    createdAt: string;
    updatedAt: string;
    addrCountry: string;
    addrState: string;
    email: string;
    phone: string;
    gender: string;
    nomeSocial: null;
    userType: number;
};

class CompanyEmployeeController {
    // /company/employee/:companyId
    async getCompanyEmployeeList(req: Request, res: Response) {
    try {
        const { companyId } = req.params;

        const { limit, offset, page } = req.pagination ?? new Pagination();

        const search = req.query.search ? String(req.query.search) : '';

        const containSearch = `%${search}%`;

        const numericCompanyId = Number(companyId);
        const companyIdNotANumber = isNaN(numericCompanyId);
        if (companyIdNotANumber) throw new Error('Company ID must be an integer number');

        const company = await prisma.salCompany.findUnique({
        where: { id: numericCompanyId },
        });
        if (!company) throw new Error('Company not found');

        const employeesPromise = prisma.$queryRaw<Employee[]>`
                SELECT se.*, seg."description" AS groupname
                FROM salesportal."SalCompany" sc
                JOIN salesportal."SalEmployee" se
                ON sc.id = se."salCompanyId"
                LEFT JOIN salesportal."SalEmployeeGroup" seg
                ON se."SalEmployeeGroupId" = seg.id
                WHERE sc.id = ${company.id}
                ${
                    search && search.trim() !== ''
                    ? Prisma.sql`
                        AND (
                            se."document" ILIKE ${containSearch} OR
                            se."name" ILIKE ${containSearch} OR
                            se."cardNumber" ILIKE ${containSearch} OR
                            seg."description" ILIKE ${containSearch}
                        )
                    `
                    : Prisma.empty
                }
                ORDER BY se.name
                LIMIT ${limit}
                OFFSET ${offset}
            `;

        const employeeCountPromise = await prisma.$queryRaw<{ count: number }[]>`
                SELECT count(*)::int
                FROM salesportal."SalCompany" sc
                JOIN salesportal."SalEmployee" se
                ON sc.id = se."salCompanyId"
                LEFT JOIN salesportal."SalEmployeeGroup" seg
                ON se."SalEmployeeGroupId" = seg.id
                WHERE sc.id = ${company.id}
                ${
                    search && search.trim() !== ''
                    ? Prisma.sql`
                        AND (
                            se."document" ILIKE ${containSearch} OR
                            se."name" ILIKE ${containSearch} OR
                            se."cardNumber" ILIKE ${containSearch} OR
                            seg."description" ILIKE ${containSearch}
                        )
                    `
                    : Prisma.empty
                }
            `;

        const [employees, employeeCount] = await Promise.all([employeesPromise, employeeCountPromise]);

        const total = employeeCount[0].count;

        const paginatedResponse: PaginatedResponse<Employee> = {
        total,
        count: employees.length,
        page,
        data: employees,
        };

        return res.json(paginatedResponse);
    } catch (error) {
        console.error('Error while fetching company employees data:', error);
        return res.status(500).json({
        message: 'An unexpected error occurred.',
        error: error instanceof Error ? error.message : '',
        });
    }
    }
}

export { CompanyEmployeeController };
