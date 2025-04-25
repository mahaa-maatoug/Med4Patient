// reset-password.service.ts
import { Injectable } from '@nestjs/common';
import { UserRepository } from './user.repository';
import { BcryptGateway } from '../../gateways/bcrypt.gateway';
import { UserMail } from '../mail/usermail';




@Injectable()
export class ResetPasswordService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly bcryptGateway: BcryptGateway,
    private readonly userMail: UserMail,
  ) {}

  private generateResetCode(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  async sendResetCode(email: string): Promise<void> {
    const user = await this.userRepository.findOneByEmail(email);
    if (!user) return; // Don't reveal if user doesn't exist

    const resetCode = this.generateResetCode();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

    user.resetPasswordCode = resetCode;
    user.resetPasswordExpires = expiresAt;
    await this.userRepository.save(user);

    await this.userMail.SendResetPassword(email, resetCode);
  }

  async verifyResetCode(email: string, code: string): Promise<boolean> {
    const user = await this.userRepository.findOneByEmail(email);
    if (!user || !user.resetPasswordCode || !user.resetPasswordExpires) {
      return false;
    }
    return (
      user.resetPasswordCode === code &&
      new Date() < user.resetPasswordExpires
    );
  }

  async resetPassword(
    email: string,
    code: string,
    newPassword: string,
  ): Promise<void> {
    const isValid = await this.verifyResetCode(email, code);
    if (!isValid) throw new Error('Invalid or expired code');

    const user = await this.userRepository.findOneByEmail(email);
    if (!user) throw new Error('User not found');

    user.password = await this.bcryptGateway.encrypt(newPassword);
    user.resetPasswordCode = undefined;
    user.resetPasswordExpires = undefined;
    await this.userRepository.save(user);
  }
}