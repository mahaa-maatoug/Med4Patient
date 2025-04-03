import { IsOptional, IsString, MinLength } from 'class-validator';


export class UpdateUser {
  @IsOptional()
  @IsString()
  firstName?: string;

  @IsOptional()
  @IsString()
  lastName?: string;



  @IsOptional()
  @IsString()
  @MinLength(6)
  password?: string;

}
