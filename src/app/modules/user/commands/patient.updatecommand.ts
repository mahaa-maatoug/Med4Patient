import { Address } from '../../../../core/models/Address';

export class UpdatePatientCommand {
  firstName?: string;
  lastName?: string;
  phone?: string;
  email?: string;
  address?: Address[];
}
