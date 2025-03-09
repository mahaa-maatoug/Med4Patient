import { Controller, Get } from '@nestjs/common';

@Controller('patients')
export class PatientController {
  @Get()
  findAll(): string {
    return 'This action returns all patients';
  }
}
