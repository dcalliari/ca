import { Request, Response } from 'express';
import { Prisma, SalEmployee } from '@prisma/client';
import { prisma } from '../../config/database.config';
import { Pagination, PaginatedResponse } from '../../utils/pagination.utils';
import { removeSpecialCharactersAndSpaces } from '../../utils/formatter.utils';

type EmployeeRecharge = {
    id: number;
    companyname: string;
    employeename: string;
    orderdate: string;
    value: number;
    cardNumber: string;
    paymentDate: string;
};

type SalEmployeeAddressData = {
    addrZipCode: string | null;
    addrStreet: string | null;
    addrNbr: string | null;
    addrComplement: string | null;
    addrDistrict: string | null;
    addrCity: string | null;
    addrState: string | null;
};

type SalEmployeeUpdateData = {
    externalId: number | null;
    name: string | null;
    birthDate: Date | null;
    updateMotherName: boolean;
    motherName: string | null;
    document: string;
    gender: string | null;
    updatePhone: boolean;
    phone: string | null;
    updateEmail: boolean;
    email: string | null;
    formatedLogical: string | null;
    updateAddress: boolean;
    addressData: SalEmployeeAddressData | null;
};

class EmployeeController {
    // /employee/:orderId
    async getEmployeeOrder(req: Request, res: Response) {
        const { orderId } = req.params;

        const { limit, offset, page } = req.pagination ?? new Pagination();

        try {
            const employees: any[] = await prisma.$queryRaw`
                    select 
                        se."name",
                        se."document" ,
                        soi.id,
                        soi."cardNumber",
                        soi.value,
                        se."cardNumber" as "newCard"
                    from salesportal."SalEmployee" se 
                    join salesportal."SalOrderItem" soi on se.id = soi."salEmployeeId" 
                    join salesportal."SalOrder" so on soi."salOrderId" = so.id 
                    where soi."cardNumber" = 'sem cartão' and so.id = ${Number(orderId)}
                    order by se."name" asc
                    LIMIT ${limit}
                    OFFSET ${offset}
                `;

            const employeesCount = await prisma.$queryRaw<{ count: number }[]>`
                    select count(*)::int
                    from salesportal."SalOrder" so 
                    join salesportal."SalOrderItem" soi on so.id = soi."salOrderId" 
                    where so.id = ${orderId}::integer and soi."cardNumber" = 'sem cartão'
                `;

            const total = Number(employeesCount[0].count);

            return res.status(200).json({
            data: employees,
            count: employees.length,
            total,
            page,
            });
        } catch (error) {
            console.error('Error while fetching company orders data:', error);
            return res.status(500).json({
            message: 'An unexpected error occurred.',
            error: error instanceof Error ? error.message : '',
            });
        }
    }
    // /employee/:employeeId/recharges
    async getEmployeeRecharges(req: Request, res: Response) {
        try {
          const { limit, offset, page } = req.pagination ?? new Pagination();
    
          const { employeeId } = req.params;
    
          const numericEmployeeId = Number(employeeId);
          const employeeIdNotANumber = isNaN(numericEmployeeId);
          if (employeeIdNotANumber) throw new Error('Employee ID must be an integer number');
    
          const employee = await prisma.$queryRaw<SalEmployee[]>`
                    SELECT * FROM salesportal."SalEmployee" se
                    WHERE se.id = ${numericEmployeeId}
                    LIMIT 1;
                `;
          if (employee.length === 0) throw new Error('Employee not found');
    
          const employeeRechargesPromise = prisma.$queryRaw<EmployeeRecharge[]>`
                    SELECT so.id as orderid, sc."name" as companyname, se."name" AS employeename, so."createdAt" as orderdate, soi.value, 
                    se."cardNumber" , so."paymentDate", so."externalId" ,			
                        salesportal.FnGetOrderStatus(
                            se."cardNumber",
                            so."externalId"::integer
                        ) ,
                        se."cardNumber", crod.id AS detailid
                    FROM salesportal."SalEmployee" se
                    JOIN salesportal."SalOrderItem" soi ON se.id = soi."salEmployeeId"
                    JOIN salesportal."SalOrder" so ON so.id = soi."salOrderId"
                    JOIN salesportal."SalCompany" sc ON sc.id = so."salCompanyId"
                    JOIN commerce."ComRechargeOrder" cro ON cro.id = so."externalId"
                    JOIN commerce."ComRechargeOrderDetail" crod ON crod."comRechargeOrderId" = cro.id
                    JOIN commerce."ComRechargeOrderDetailUser" crodu ON crodu."usrUserDocumentValue" = se."document"
                    AND crodu."comRechargeOrderDetailId"  = crod.id
                    WHERE se."document" = ${employee[0].document}
                    AND so."isPaid"
                    AND   so."isReleased"
                    ORDER BY so."createdAt" desc
                    LIMIT ${limit}
                    OFFSET ${offset}
                `;
    
          const employeeRechargesCountPromise = prisma.$queryRaw<{ count: number }[]>`
                    SELECT count(*)::int
                    FROM salesportal."SalEmployee" se
                    JOIN salesportal."SalOrderItem" soi ON se.id = soi."salEmployeeId"
                    JOIN salesportal."SalOrder" so ON so.id = soi."salOrderId"
                    JOIN salesportal."SalCompany" sc ON sc.id = so."salCompanyId"
                    JOIN commerce."ComRechargeOrder" cro ON cro.id = so."externalId"
                    JOIN commerce."ComRechargeOrderDetail" crod ON crod."comRechargeOrderId" = cro.id
                    JOIN commerce."ComRechargeOrderDetailUser" crodu ON crodu."usrUserDocumentValue" = se."document"
                    AND crodu."comRechargeOrderDetailId"  = crod.id
                    WHERE se."document" = ${employee[0].document}
                    AND so."isPaid"
                    AND   so."isReleased"
                `;
    
          const [employeeRecharges, employeeRechargesCount] = await Promise.all([
            employeeRechargesPromise,
            employeeRechargesCountPromise,
          ]);
    
          const total = employeeRechargesCount[0].count;
    
          const paginatedResponse: PaginatedResponse<EmployeeRecharge> = {
            total,
            count: employeeRecharges.length,
            page,
            data: employeeRecharges,
          };
    
          return res.json(paginatedResponse);
        } catch (error) {
          console.error('Error while fetching employee recharges data:', error);
          return res.status(500).json({
            message: 'An unexpected error occurred.',
            error: error instanceof Error ? error.message : '',
          });
        }
    }
    // /employee/document/:documentId
    async updateEmployeeInformation(req: Request, res: Response) {
        try {
            const { documentId } = req.params;

            const updateData = req.body as SalEmployeeUpdateData;

            const employees = await prisma.$queryRaw<{ id: string; userType: number }[]>`
                    SELECT id, "userType" FROM salesportal."SalEmployee" se
                    WHERE se."document" = ${documentId}
                `;
            if (!employees.length) throw new Error('Employee not found.');

            for await (const { id, userType } of employees) {
            if (id === null) continue;
            // Em caso de cartão empresa, o processo é pulado
            if (userType === 1) continue;

            await prisma.$queryRaw`
                        UPDATE salesportal."SalEmployee"
                        SET "externalId" = ${updateData.externalId},
                        "name" = ${updateData.name?.toUpperCase()},
                        "birthDate" = ${updateData.birthDate}::timestamptz,
                        "document" = ${removeSpecialCharactersAndSpaces(updateData.document)},
                        ${
                            updateData.updateMotherName
                            ? Prisma.sql`
                            "motherName" = ${updateData.motherName?.toUpperCase()},
                        `
                            : Prisma.empty
                        }
                        ${
                            updateData.updateAddress
                            ? Prisma.sql`
                            "addrZipCode" = ${removeSpecialCharactersAndSpaces(updateData.addressData?.addrZipCode ?? '')},
                            "addrStreet" = ${updateData.addressData?.addrStreet},
                            "addrNbr" = ${updateData.addressData?.addrNbr},
                            "addrCity" = ${updateData.addressData?.addrCity},
                            "addrComplement" = ${updateData.addressData?.addrComplement},
                            "addrDistrict" = ${updateData.addressData?.addrDistrict},
                            "addrState" = ${updateData.addressData?.addrState},
                        `
                            : Prisma.empty
                        }
                        ${
                            updateData.updateEmail
                            ? Prisma.sql`
                            "email" = ${updateData.email},
                        `
                            : Prisma.empty
                        }
                        ${
                            updateData.updatePhone
                            ? Prisma.sql`
                            "phone" = ${updateData.phone},
                        `
                            : Prisma.empty
                        }
                        "updatedAt" = current_timestamp
                        WHERE id = ${id};
                    `;
            }

            return res.status(200).send();
        } catch (error) {
            return res
            .status(500)
            .json({ message: 'An unexpected error occurred.', error: error instanceof Error ? error.message : '' });
        }
    }
}

export { EmployeeController };
