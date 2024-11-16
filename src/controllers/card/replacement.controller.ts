import { Request, Response } from 'express';
import { prisma } from '../../config/database.config';
import { PaymentsAPI } from '../../services/payment.service';

const paymentsAPI = new PaymentsAPI();

class ReplacementController {
  // /card/replacement
  async getReplacementRequestList(req: Request, res: Response) {
    const { startDate, endDate, search, page = 1, limit = 10, isActive, cscId } = req.query;

    const offset = (Number(page) - 1) * Number(limit);

    let query = `
            select 
                mm.mreq_id,
                uu."name" ,
                mm.mreq_oldcardinfo ,
                mm.mreq_createdat,
                mm.mreq_requestdate,
                mm.mreq_paymentdate,
                mm.mreq_value / 100 as value,
                mm.mreq_ispaid ,
                mm.mreq_newcardinfo,
                mm.mreq_isactive ,
                mm.mreq_deactivationreason,
                mm.mreq_modifiedby
            from media.med_mediarequest mm 
            join "user"."UsrUser" uu on mm.usr_userid = uu.id 
            where true
        `;

    if (startDate && endDate) {
      query += ` and date(mm.mreq_requestdate) between '${startDate}' and '${endDate}'`;
    }

    if (isActive !== undefined) {
      query += ` and mm.mreq_isactive = ${isActive}`;
    }

    if (cscId) {
      query += ` and mm.csc_id = ${cscId}`;
    }

    if (search) {
      query += `
                and (
                    uu."name" ILIKE '%${search}%' 
                    or mm.mreq_oldcardinfo ILIKE '%${search}%'
                )
        `;
    }

    const countQuery = `
                SELECT COUNT(*) FROM(
            ${query}
        ) as total_count
        `;

    try {
      const totalCountResult: any[] = await prisma.$queryRawUnsafe(countQuery);

      const totalCount = totalCountResult[0]?.count;

      query += ` 
                order by 5 desc 
                LIMIT ${Number(limit)} 
                OFFSET ${offset} 
            `;

      const secondEmissions = await prisma.$queryRawUnsafe(query);

      const typeOfService = await prisma.$queryRaw`
                select * from commerce.com_servicechannel cs 
                where cs.csc_isactive = true
            `;

      return res.status(200).json({
        data: secondEmissions,
        count: Number(totalCount),
        csc: typeOfService,
      });
    } catch (error) {
      return res.status(500).json({
        error: true,
        message: 'Internal server error',
      });
    }
  }
  // /card/replacement/contact/:mreqId
  async getContactByMseId(req: Request, res: Response) {
    const { mreqId } = req.params;
    try {
      const contact: any[] = await prisma.$queryRaw`
                select * from media.med_mediarequestcontact mm
                where mm.mreq_id = ${Number(mreqId)}
            `;

      const editedBy: any[] = await prisma.$queryRaw`
                select 
                    mm.mreq_id,
                    uu."name",
                    mm.mreq_oldcardinfo ,
                    mm.mreq_isactive,
                    mm.mreq_deactivationreason,
                    mm.mreq_modifiedby,
                    cs.csc_name,
                    mreq_paymenttransactionid,
                    mreq_ispaid
                from media.med_mediarequest mm 
                join "user"."UsrUser" uu on mm.usr_userid = uu.id 
                join commerce.com_servicechannel cs on cs.csc_id = mm.csc_id 
                where mm.mreq_id = ${Number(mreqId)}
            `;

      let existingBilletData = null;

      if (!editedBy[0].mreq_ispaid) {
        existingBilletData = await paymentsAPI.getTransactions(Number(editedBy[0].mreq_paymenttransactionid));
      }

      return res.status(200).json({
        contact: contact[0],
        editedBy: editedBy[0],
        billetURL: existingBilletData?.url,
      });
    } catch (error) {
      return res.status(500).json({
        error: true,
        message: 'Internal server error',
      });
    }
  }
  // /card/replacement/request/:mreqId
  async getReplacementRequest(req: Request, res: Response) {
    const { mreqId } = req.params;

    try {
      const userData: any[] = await prisma.$queryRaw`
                select  
                    uu."name", 
                    mm.mreq_oldcardinfo , 
                    mm.mreq_requestdate 
                from media.med_mediarequest mm 
                join "user"."UsrUser" uu on mm.usr_userid = uu.id 
                where mm.mreq_id = ${Number(mreqId)}
            `;

      return res.status(200).json(userData[0]);
    } catch (error) {
      return res.status(500).json({
        error: true,
        message: 'Internal server error',
      });
    }
  }
  // /card/replacement/cancelRequest/:mreqId
  async cancelReplacementRequest(req: Request, res: Response) {
    const { mreqId } = req.params;
    const { observation, editedBy } = req.body;

    try {
      await prisma.$executeRaw`
                UPDATE media.med_mediarequest 
                SET mreq_deactivationreason = ${observation}, mreq_isactive = false, mreq_modifiedby = ${editedBy}
                WHERE mreq_id = ${Number(mreqId)}
            `;

      return res.status(200).send();
    } catch (error) {
      return res.status(500).json({
        error: true,
        message: 'Internal server error',
      });
    }
  }
}

export { ReplacementController };
