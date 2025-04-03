import { Injectable } from "@nestjs/common";
import { PatientRepository } from "src/app/modules/patient/patient.repository";
import { ObjectId } from 'mongodb';
import { UpdatePatientCommand } from '../user/commands/patient.updatecommand';

@Injectable()
export class PatientService {
  constructor(private readonly patientRepository: PatientRepository) {}



async findById(id: string) {
  try {
    const objectId = new ObjectId(id); // ✅ Convertir l'ID en ObjectId
    return await this.patientRepository.findOne({ _id: objectId });
  } catch (error) {
    console.error("Invalid ID format:", error);
    return null;
  }
}


// Update a patient by ID
  async updatePatient(id: string, updateData: UpdatePatientCommand) {
    return this.patientRepository.findOneAndUpdate({ _id: id }, updateData, { new: true });
  }
}
