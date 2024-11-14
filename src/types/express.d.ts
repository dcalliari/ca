import 'express';

import { Pagination } from '../utils/pagination.utils';

declare module 'express' {
  interface Request {
    user_id?: string;
    pagination?: Pagination;
  }
}
