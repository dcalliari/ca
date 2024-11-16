import { Request, Response } from 'express';
import axios, { isAxiosError } from 'axios';
import { Prisma } from '@prisma/client';
import { prisma } from '../../config/database.config';

class StatusController {
  // /card/status/unlock/:companyId
  async getAllCardsToUnlock(req: Request, res: Response) {
    const { companyId } = req.params;

    try {
      const employees = await prisma.$queryRaw`
                SELECT DISTINCT 
                    se."name", 
                    se."cardNumber",
                    mm.id, 
                    mm.receiveddate_tz, 
                    mm.receivedby,
                    mm.csn::text
                FROM salesportal."SalEmployee" se
                JOIN salesportal."SalCompany" sc ON se."salCompanyId" = sc.id
                JOIN media."MedMedia" mm ON mm."formatedLogical" = se."cardNumber"
                WHERE se."salCompanyId" = ${Number(companyId)}
                AND mm."reissueSequence" = 1
                AND mm."isActive"
                AND mm.csn IS NOT NULL
                AND mm.receiveddate_tz IS NULL
                AND mm.receivedby IS NULL
            `;

      return res.status(200).json(employees);
    } catch (error: any) {
      return res.status(500).json({
        message: 'Internal server error',
        error: error.message,
      });
    }
  }
  // /card/status/update-not-unlock
  async updateCardsToUnlock(req: Request, res: Response) {
    const { employeesId } = req.body;

    try {
      await prisma.$queryRaw`
                UPDATE media."MedMedia"
                SET "receiveddate_tz" = ${new Date()}::timestamptz, 
                    "receivedby" = 'OWNER'
                WHERE "id" IN (${Prisma.join(employeesId)})    
            `;

      const csnCardsNumbers = await prisma.$queryRaw<{ csn: string }[]>`
                SELECT mm."csn"::text 
                FROM media."MedMedia" mm 
                WHERE mm."id" IN (${Prisma.join(employeesId)})
            `;

      const csnFormated = csnCardsNumbers.map((card) => ({
        csn: Number(card.csn),
      }));

      const response = await axios.post(process.env.UNLOCK_CARD_URL!, csnFormated);

      console.log(new Date(), 'response unlock card...', response.data);

      return res.status(200).json({ error: false });
    } catch (error: any) {
      if (isAxiosError(error)) {
        return res.status(500).json({
          error: error.response?.data,
          message: 'Error in AXIOS request',
        });
      }

      return res.status(500).json({
        message: 'Internal Server error',
        error: error.message,
      });
    }
  }
}

export { StatusController };
