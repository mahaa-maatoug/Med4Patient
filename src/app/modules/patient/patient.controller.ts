import { Body, Controller, Get, Param, Put, Res } from '@nestjs/common';
import { PatientService } from './patient.service';

import { UpdatePatientCommand } from '../user/commands/patient.updatecommand';
import { Response } from 'express';

@Controller('/patient')
export class PatientController {
  constructor(private readonly patientService: PatientService) {}

  @Get(':id')
  async getPatientById(@Param('id') id: string, @Res() res: Response): Promise<Response> {
    try {
      const patient = await this.patientService.findById(id);
      if (!patient) {
        return res.status(404).json({ message: 'Patient not found' });
      }
      return res.status(200).json({ patient });
    } catch  {
      return res.status(500).json({ message: 'Server Error' });
    }
  }

  // Update a patient by ID
  @Put(':id')
  async updateById(
    @Param('id') id: string, // Retrieve the ID from the URL parameter
    @Body() updateData: UpdatePatientCommand, // The data for the update
    @Res() res: Response
  ): Promise<Response> {
    try {
      const updatedPatient = await this.patientService.updatePatient(id, updateData);
      if (!updatedPatient) {
        return res.status(404).json({ message: 'Patient not found' });
      }
      return res.status(200).json({
        message: 'Patient profile updated successfully',
        patient: updatedPatient,
      });
    } catch  {
      return res.status(500).json({ message: 'Server Error' });
    }
  }

}




