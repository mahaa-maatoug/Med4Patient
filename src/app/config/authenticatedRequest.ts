import { Request } from "express";
import { UserIdentity } from "../../core/models/UserIdentity";


export interface AuthenticatedRequest extends Request {
  identity: UserIdentity;
}
