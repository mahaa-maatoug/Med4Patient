import { Role } from '../enums/Role';
export interface UserIdentity {
    id: string;
    phone?: string;
    email: string;
    role: Role;
}
