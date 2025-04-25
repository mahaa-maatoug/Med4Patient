import { Body, Controller, Post } from '@nestjs/common';
import { ResetPasswordService } from './reset-password.service';

@Controller('auth/reset-password')
export class ResetPasswordController {
  constructor(private readonly resetPasswordService: ResetPasswordService) {}

  @Post('request-code')
  async requestCode(@Body('email') email: string) {
    await this.resetPasswordService.sendResetCode(email);
    return { message: 'If account exists, reset code sent' };
  }

  @Post('verify-code')
  async verifyCode(
    @Body('email') email: string,
    @Body('code') code: string,
  ) {
    const isValid = await this.resetPasswordService.verifyResetCode(email, code);
    return { isValid };
  }

  @Post('reset')
  async resetPassword(
    @Body('email') email: string,
    @Body('code') code: string,
    @Body('newPassword') newPassword: string,
  ) {
    await this.resetPasswordService.resetPassword(email, code, newPassword);
    return { message: 'Password reset successfully' };
  }
}