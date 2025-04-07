import { IsEmail, IsOptional, IsString, MinLength } from 'class-validator';


export class UpdateUser {
  @IsString()
  @IsOptional()
  firstName?: string;

  @IsString()
  @IsOptional()
  lastName?: string;

  @IsEmail()
  @IsOptional()
  email?: string;

  @IsString()
  @IsOptional()
  password?: string;

}
