import { IsString, IsNotEmpty,  IsOptional, IsEnum } from 'class-validator';
import { PrescriptionStatus } from '../../../core/enums/PrescriptionStatus';

export class CreateOrdonnanceDto {
  @IsNotEmpty()
  @IsString()
  patientId: string;

  @IsNotEmpty()
  @IsString()
  pharmacyId: string;



  @IsOptional()
  @IsString()
  note?: string;



  @IsOptional() // Make this optional
  @IsEnum(PrescriptionStatus)
  prescriptionStatus?: PrescriptionStatus = PrescriptionStatus.UPLOADED;



}

export class UpdateOrdonnanceDto {
  @IsOptional()
  @IsString()
  note?: string;
}
