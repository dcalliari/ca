import { Request, Response, NextFunction } from 'express';
import { Pagination } from '../utils/pagination.utils';

export async function ensurePagination(request: Request, _: Response, next: NextFunction) {
  console.log('CHEGOU NO MIDDLEWARE');
  console.log('QUERY', request.query);
  console.log('PARAMS', request.params);
  console.log('LIMIT', request.query.limit);
  console.log('PAGE', request.query.page);

  const queryLimit = request.query.limit ? Number(request.query.limit) : 0;
  const queryPage = request.query.page ? Number(request.query.page) : 0;

  const limit = queryLimit <= 0 ? 10 : Number(request.query.limit);
  const page = queryPage <= 0 ? 1 : Number(request.query.page);

  request.pagination = new Pagination(limit, page);

  next();
}
