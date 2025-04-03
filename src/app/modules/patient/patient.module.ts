import { Module } from '@nestjs/common';
import { PatientController } from './patient.controller';
import { PatientRepository } from './patient.repository';
import { MongooseModule } from '@nestjs/mongoose';
import { Patient, PatientSchema } from './patient.entity';
import { PatientService } from './patient.service';
// ... existing code ...

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Patient.name, schema: PatientSchema }]), // Register the model
  ],
  controllers: [PatientController],
  providers: [PatientService, PatientRepository], // Ajouter PatientService
  exports: [PatientService, PatientRepository],
})
export class PatientModule {}
