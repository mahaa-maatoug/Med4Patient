import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Patient } from 'src/app/modules/patient/patient.entity';
import { UpdatePatientCommand } from '../user/commands/patient.updatecommand'; // Adjust the path as per your file structure

@Injectable()
export class PatientRepository {
  constructor(@InjectModel(Patient.name) private readonly patientModel: Model<Patient>) {}

  // Find patient by email
  async findOneByEmail(email: string): Promise<Patient | null> {
    return this.patientModel.findOne({ email }).exec();
  }
  async findOne(filter: object) {
    return this.patientModel.findOne(filter).exec();
  }
// In PatientRepository
  async findOneById(id: string): Promise<Patient | null> {
    return this.patientModel.findOne({ _id: id }).exec();
  }

  // Update patient by ID
  async findOneAndUpdate(
    filter: object,
    updateData: UpdatePatientCommand,
    options: object,
  ) {
    return this.patientModel.findOneAndUpdate(filter, updateData, options).exec();
  }S
}
