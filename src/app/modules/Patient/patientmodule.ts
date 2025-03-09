import { Module } from '@nestjs/common';
import { PatientController } from 'src/app/modules/Patient/Patientcontroller';

import { PatientRepository } from './PatientRepository'; // Assuming you have a repository

@Module({
  imports: [], // Add any other modules you need to import
  controllers: [PatientController],
  providers: [ PatientRepository],
})
export class patientmodule {}
