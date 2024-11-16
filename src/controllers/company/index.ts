import { Request, Response } from 'express';
import { Prisma } from '@prisma/client';
import { prisma } from '../../config/database.config';
import { PaginatedResponse } from '../../utils/pagination.utils';
  
type Company = {
    username: string;
    email: string;
    salcompany: number;
    id: number;
    salCompanyId: number;
    secUserId: number;
    userdocument: string;
    document: string;
};

class CompanyController {
    // /company
    async getCompanyList(req: Request, res: Response) {
        try {
            let { take = 10, skip = 0 } = req.query;

            take = Number(take);
            skip = Number(skip);

            const search = req.query.search ? String(req.query.search) : '';

            const containSearch = `%${search}%`;

            const companiesPromise = prisma.$queryRaw<Company[]>`
                    SELECT sc.name as companyname, su."name" AS username, su."document" AS userdocument, su.email, sc.id AS salcompany, su.id, scc."salCompanyId", scc."secUserId", sc."document"
                    FROM salesportal."SalCompany" sc, "security"."SecUser" su, salesportal."SalCompanyCredential" scc
                    WHERE 1 = 1
                    AND sc.id = scc."salCompanyId" 
                    AND su.id = scc."secUserId"
                    ${
                        search && search.trim() !== ''
                        ? Prisma.sql`
                            AND (
                                sc.name ILIKE ${containSearch} OR
                                su."name" ILIKE ${containSearch} OR
                                sc."document" ILIKE ${containSearch}
                            )
                        `
                        : Prisma.empty
                    }
                    ORDER BY sc.name ASC
                    LIMIT ${take}
                    OFFSET ${skip}
                `;

            const companyCountPromise = prisma.$queryRaw<{ count: number }[]>`
                    SELECT count(*)::int
                    FROM salesportal."SalCompany" sc, "security"."SecUser" su, salesportal."SalCompanyCredential" scc
                    WHERE 1 = 1                
                    AND sc.id = scc."salCompanyId" 
                    AND su.id = scc."secUserId"
                    ${
                        search && search.trim() !== ''
                        ? Prisma.sql`
                            AND (
                                sc.name ILIKE ${containSearch} OR
                                su."name" ILIKE ${containSearch} OR
                                sc."document" ILIKE ${containSearch}
                            )
                        `
                        : Prisma.empty
                    }
                `;

            const [companies, companyCount] = await Promise.all([companiesPromise, companyCountPromise]);

            const total = companyCount[0].count;

            const paginatedResponse: PaginatedResponse<Company> = {
            total,
            count: companies.length,
            data: companies,
            take: Number(take),
            skip: Number(skip),
            };

            return res.json(paginatedResponse);
        } catch (error) {
            console.error('Error while fetching companies and secUsers data:', error);
            return res.status(500).json({
            message: 'An unexpected error occurred.',
            error: error instanceof Error ? error.message : '',
            });
        }
    }
    // /company/:companyId
    async getCompany(req: Request, res: Response) {
        const { companyId } = req.params;
    
        try {
            const company = await prisma.salCompany.findFirst({
            where: {
                AND: [{ id: Number(companyId) }],
            },
            include: {
                SalCompanyCredential: {
                include: {
                    SecUser: {
                    select: {
                        name: true,
                        document: true,
                        email: true,
                    },
                    },
                },
                },
            },
            });
    
            if (company) {
            return res.status(200).json(company);
            }
            return res.status(404).json({ message: 'Active company not found.' });
        } catch (error) {
            return res
            .status(500)
            .json({ message: 'An unexpected error occurred.', error: error instanceof Error ? error.message : '' });
        }
    }
    // /company/:companyId
    async editCompany(req: Request, res: Response) {
    try {
        const { companyId } = req.params;
        const { newEmail, newName, newDocument } = req.body;

        const numericCompanyId = Number(companyId);
        const companyIdNotANumber = isNaN(numericCompanyId);
        if (companyIdNotANumber) throw new Error('Company ID must be an integer number');

        const company = await prisma.salCompany.findUnique({
        where: { id: Number(companyId) },
        include: { SalCompanyCredential: true },
        });
        if (!company) throw new Error('Company not found');

        const companySecUser = await prisma.secUser.findUnique({
        where: { id: company.SalCompanyCredential[0].secUserId },
        });
        if (!companySecUser) throw new Error('Company SecUser not found');

        const sameEmail = companySecUser.email === newEmail;

        if (!sameEmail) {
        const alreadyTakenEmail = await prisma.secUser.findUnique({
            where: { email: newEmail },
        });
        if (alreadyTakenEmail) throw new Error('E-mail already in use');
        }

        const sameDocument = companySecUser.document === newDocument;

        if (!sameDocument) {
        const alreadyTakenDocument = await prisma.secUser.findUnique({
            where: { document: newDocument },
        });
        if (alreadyTakenDocument) throw new Error('Document already in use');
        }

        await prisma.secUser.update({
        where: { id: companySecUser.id },
        data: {
            name: newName ?? companySecUser.name,
            email: newEmail ?? companySecUser.email,
            document: newDocument ?? companySecUser.document,
        },
        });

        return res.status(200).send();
    } catch (error) {
        console.error('Error while editing company sec user email:', error);
        return res.status(500).json({
        message: 'An unexpected error occurred.',
        error: error instanceof Error ? error.message : '',
        });
    }
    }
}

export { CompanyController };
