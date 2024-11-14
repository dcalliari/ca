export interface PaginatedResponse<T> {
  count: number;
  total: number;
  page?: number;
  data: T[];
  take?: number;
  skip?: number;
}

export class Pagination {
  public limit: number;

  public page: number;

  public offset: number;

  constructor(limit: number = 10, page: number = 1) {
    this.limit = limit;
    this.page = page;

    this.offset = (page - 1) * limit;
  }
}
