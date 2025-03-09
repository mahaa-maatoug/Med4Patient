import { Model } from 'mongoose';
import { Patient } from './patient';

export declare class PatientRepository {
  private readonly patientModel;
  constructor(patientModel: Model<Patient>);
  findOneById(id: string): Promise<Patient | null>;
  findOneByUserId(id: string): Promise<Patient | null>;
  findOneByEmail(email: string): Promise<Patient | null>;
  save(patientData: Partial<Patient>): Promise<Patient>;
  update(id: string, updateData: Partial<Patient>): Promise<Patient | null>;
  delete(id: string): Promise<boolean>;
}
