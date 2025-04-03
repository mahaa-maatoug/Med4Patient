import { Role } from '../enums/Role';
import { ObjectId } from 'mongodb';
export interface UserIdentity {
    _id: ObjectId;
    id: string;
    phone?: string;
    email: string;
    role: Role;
}
