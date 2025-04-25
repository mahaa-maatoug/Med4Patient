import { IsString, IsOptional, IsEnum, IsArray } from 'class-validator';
import { PrescriptionStatus } from '../../../core/enums/PrescriptionStatus';

export class CreateOrdonnanceDto {




  @IsOptional()
  @IsString()
  note?: string;



  @IsOptional() // Make this optional
  @IsEnum(PrescriptionStatus)
  prescriptionStatus?: PrescriptionStatus = PrescriptionStatus.UPLOADED;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  medications?: string[];

}

export class UpdateOrdonnanceDto {




  @IsOptional()
  @IsString()
  note?: string;



  @IsOptional() // Make this optional
  @IsEnum(PrescriptionStatus)
  prescriptionStatus?: PrescriptionStatus = PrescriptionStatus.UPLOADED;
}
