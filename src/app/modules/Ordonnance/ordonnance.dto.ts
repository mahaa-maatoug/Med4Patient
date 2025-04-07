import { IsString,  IsOptional, IsEnum } from 'class-validator';
import { PrescriptionStatus } from '../../../core/enums/PrescriptionStatus';

export class CreateOrdonnanceDto {




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



  @IsOptional() // Make this optional
  @IsEnum(PrescriptionStatus)
  prescriptionStatus?: PrescriptionStatus = PrescriptionStatus.UPLOADED;
}
