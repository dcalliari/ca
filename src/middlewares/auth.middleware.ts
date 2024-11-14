import { NextFunction, Request, Response } from 'express';
import { prisma } from '../config/database.config';

const { jwtDecode } = require('jwt-decode');

export const authMiddleware = async (req: any, res: Response, next: NextFunction) => {
  const idToken = req.headers.authorization;
  console.log(req.headers);
  if (!idToken) {
    console.warn(new Date(), 'no auth token was provided');
    res.status(401).send('Header > Authorization é obrigatório!');
    return;
  }

  try {
    const cognito = await jwtDecode(idToken);
    console.log(cognito);
    req.cognito = cognito;
  } catch (err) {
    console.error(`### [ERROR]  ${new Date().toLocaleString('pt-BR')} - Error on jwtDecode`);
    console.log('🚀------------------------🚀', err);
  }

  if (req.cognito.exp <= Math.round(new Date().getTime() / 10000)) {
    const errormsg = `exp: ${req.cognito.exp}, atual: ${Math.round(new Date().getTime() / 10000)}`;
    console.error(new Date(), errormsg);
    res.status(401).send(errormsg);
    return;
  }

  try {
    const user = await prisma.$queryRaw<Array<ProtectedRequest['user']>>`
    select *, su."blameUser" as "createdBy"
    from "system"."SysUser" su where sub = ${req.cognito.sub}`;

    if (!user[0]) {
      console.error(new Date(), 'user not found for', req.cognito);
      res.status(401).send('User not found');
      return;
    }

    req.user = user[0];
    next();
  } catch (error: any) {
    res.status(400).json(error.message ? error.message : error);
    return;
  }
};

export interface ProtectedRequest extends Request {
  user?: {
    sub: string;
    // NOTA: ESSE É O BLAMEUSER
    email: string;
    sysUserGroupId?: number | null;
    isActive: boolean;
    createdBy?: string | null;
    createdAt?: Date | null;
    updatedAt: Date;
    systemType: 'web' | 'pos' | 'collector';
    comMerchantId?: number | null;
    usrOperatorId?: number | null;
    createBySub?: string | null;
    lastActive?: Date | null;
  };

  cognito?: {
    sub: string;
    'cognito:groups': string[];
    iss: string;
    client_id: string;
    origin_jti: string;
    event_id: string;
    token_use: string;
    scope: string;
    auth_time: number;
    exp: number;
    iat: number;
    jti: string;
    username: string;
  };
}
