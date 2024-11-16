import { Request, Response } from 'express';
import { OrderStatus, Prisma } from '@prisma/client';
import { prisma } from '../../config/database.config';
import { PaginatedResponse, Pagination } from '../../utils/pagination.utils';

type Order = {
  id: number;
  date: Date;
  totalValue: number;
  isPaid: boolean;
  status: string;
  paymentDate: null;
  isReleased: boolean;
  releaseDate: null;
  cancelDate: null;
  orderType: string;
  paymentMode: string;
  externalId: null | number;
}
type OrderItem = {
  id: number;
  name: string;
  document: string;
  description: string;
  value: number;
  cardNumber: string;
  userType: number;
  fos: string;
};

class OrderController {
  // /company/order/:orderId/items
  async getOrderItems(req: Request, res: Response) {
    try {
      const { orderId } = req.params;

      const { limit, offset, page } = req.pagination ?? new Pagination();

      console.log(orderId);

      const numericOrderId = Number(orderId);
      const orderIdNotANumber = isNaN(numericOrderId);
      if (orderIdNotANumber) throw new Error('Order ID must be an integer number');

      const order = await prisma.salOrder.findUnique({
        where: { id: numericOrderId },
      });
      if (!order) throw new Error('Order not found');

      const orderItemsPromise = prisma.$queryRaw<OrderItem[]>`
                SELECT 
                    soi.id, 
                    se."name", 
                    se."document", 
                    coalesce(seg.description, '') as description, 
                    soi.value::float as value,
                    se."cardNumber" as "cardNumber",
                    se."userType",
                    fos.*
                FROM salesportal."SalOrderItem" soi 
                JOIN salesportal."SalEmployee" se ON soi."salEmployeeId" = se.id
                LEFT JOIN salesportal."SalEmployeeGroup" seg ON se."SalEmployeeGroupId" = seg.id
                LEFT JOIN salesportal.FnGetOrderStatus(se."cardNumber",${order.externalId}::integer) fos ON true
                WHERE soi."salOrderId" = ${order.id}::integer
                ORDER BY se."name"
                LIMIT ${limit}
                OFFSET ${offset}
            `;

      const orderItemsCountPromise = prisma.$queryRaw<{ count: number }[]>`
                SELECT count(*)::int
                FROM salesportal."SalOrderItem" soi
                JOIN salesportal."SalEmployee" se ON soi."salEmployeeId" = se.id
                WHERE soi."salOrderId" = ${order.id}::integer
            `;

      const [orderItems, orderItemsCount] = await Promise.all([orderItemsPromise, orderItemsCountPromise]);

      const total = orderItemsCount[0].count;

      const paginatedResponse: PaginatedResponse<OrderItem> = {
        total,
        count: orderItems.length,
        page,
        data: orderItems,
      };

      return res.json(paginatedResponse);
    } catch (error) {
      console.error('Error while fetching company order items data:', error);
      return res.status(500).json({
        message: 'An unexpected error occurred.',
        error: error instanceof Error ? error.message : '',
      });
    }
  }
  // /company/order/:companyId
  async getCompanyOrders(req: Request, res: Response) {
    try {
      const { companyId } = req.params;

      const { search, status } = req.query;

      const { limit, offset, page } = req.pagination ?? new Pagination();

      const numericCompanyId = Number(companyId);
      const companyIdNotANumber = isNaN(numericCompanyId);
      if (companyIdNotANumber) throw new Error('Company ID must be an integer number');

      const company = await prisma.salCompany.findUnique({
        where: { id: numericCompanyId },
      });
      if (!company) throw new Error('Company not found');

      let whereClause: Prisma.SalOrderWhereInput = {
        salCompanyId: company.id,
        totalValue: { gt: 0 },
        NOT: { status: { equals: 'inconsistent' } },
      };

      if (search) {
        const id = String(search).replace(/[^\d]/g, '');

        whereClause.OR = [{ id: { equals: Number(id) } }];
      }

      if (status === 'paid') {
        whereClause.OR = [{ isPaid: { equals: true } }];
      } else if (status === 'released') {
        whereClause.OR = [{ status: { equals: String(status) as OrderStatus } }, { isReleased: { equals: true } }];
      } else if (!!status) {
        whereClause.status = {
          equals: String(status) as OrderStatus,
        };
      }

      const ordersPromise = prisma.salOrder.findMany({
        select: {
          id: true,
          date: true,
          totalValue: true,
          isPaid: true,
          status: true,
          paymentDate: true,
          isReleased: true,
          releaseDate: true,
          cancelDate: true,
          orderType: true,
          paymentMode: true,
          externalId: true,
          SalOrderItem: {
            where: {
              cardNumber: 'sem cartão',
            },
            take: 1,
          },
        },
        where: whereClause,
        orderBy: { createdAt: 'desc' },
        skip: offset,
        take: limit,
      });

      const ordersCountPromise = prisma.salOrder.count({
        where: whereClause,
      });

      const [orders, ordersCount] = await Promise.all([ordersPromise, ordersCountPromise]);

      const paginatedResponse: PaginatedResponse<Order> = {
        total: ordersCount,
        count: orders.length,
        page,
        data: orders as Order[],
      };

      return res.json(paginatedResponse);
    } catch (error) {
      console.error('Error while fetching company orders data:', error);
      return res.status(500).json({
        message: 'An unexpected error occurred.',
        error: error instanceof Error ? error.message : '',
      });
    }
  }
}

export { OrderController };
