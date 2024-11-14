import axios from 'axios';
import path from 'path';
import { resolveAsync } from './resolve.service';

interface IPaymentEntity {
  id: number;
  name: string;
  document: string;
  documentType: string;
  street: string;
  number: string;
  complement: string;
  city: string;
  state: string;
  zipCode: string;
}

interface ICreatePaymentTransaction {
  payer: IPaymentEntity;
  beneficiary: IPaymentEntity;
  value: number;
  date: Date;
  dueDate: Date;
  ourNumber: string;
  billetComment?: string;
  addTransactionIdInBilletComment?: boolean;
}

interface ICreatePaymentTransactionResponse {
  id: number;
  barCode: string;
  qrcode: string;
  digitableLine: string;
  url: string;
}

interface IGetPaymentTransactionResponse {
  id: number;
  history: Array<{
    id: number;
    status: string;
    is_deleted: boolean;
  }>;
  url: string;
}

export class PaymentsAPI {
  async createTransaction(
    transactionData: ICreatePaymentTransaction
  ): Promise<ICreatePaymentTransactionResponse | null> {
    const response = await resolveAsync(
      axios.post<ICreatePaymentTransactionResponse>(process.env.PAYMENT_URL!, transactionData, {
        headers: {
          Authorization: `Bearer ${process.env.PAYMENT_TOKEN}`,
        },
      })
    );

    if (!response.success) {
      return null;
    }

    return response.data.data;
  }

  async getTransactions(transactionId: number): Promise<IGetPaymentTransactionResponse | null> {
    const response = await resolveAsync(
      axios.get<IGetPaymentTransactionResponse>(path.join(process.env.PAYMENT_URL!, String(transactionId)), {
        headers: {
          Authorization: `Bearer ${process.env.PAYMENT_TOKEN}`,
        },
      })
    );

    if (!response.success) {
      return null;
    }

    return response.data.data;
  }
}
