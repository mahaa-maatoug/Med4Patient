import { IsString, MinLength } from 'class-validator';

export class ChangePasswordDto {
  @IsString()
  @MinLength(6, { message: 'Password is too short. Minimum length is 6 characters.' })
  currentPassword: string;

  @IsString()
  @MinLength(6, { message: 'New password is too short. Minimum length is 6 characters.' })
  newPassword: string;
}
