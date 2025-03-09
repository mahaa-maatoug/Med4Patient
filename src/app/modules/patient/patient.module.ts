import { Module } from '@nestjs/common';
import { PatientController } from './patient.controller';
// ... existing code ...

@Module({
  imports: [
  ],
  controllers: [PatientController],
  providers: [],
  exports: [],
})
export class PatientModule {}
