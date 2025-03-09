import { Injectable } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer'; // Import MailerService from NestJS Mailer module

@Injectable()
export class UserMail {
  constructor(private readonly mailerService: MailerService) {}

  // Send a login email with a verification code or instructions
  async SendLoginEmail(email: string): Promise<void> {
    const subject = 'Login Instructions';
    const text = `Hello, please use the verification code to login: 123456`; // Modify with your logic

    try {
      await this.mailerService.sendMail({
        to: email, // recipient email
        subject: subject,
        text: text, // plain text
        html: `<b>${text}</b>`, // or you can use an HTML template
      });
    } catch (error) {
      console.error('Error sending login email:', error);
      throw new Error('Error sending login email');
    }
  }

  // Send password reset email with the reset code
  async SendResentPassword(email: string, resetCode: string): Promise<void> {
    const subject = 'Password Reset Instructions';
    const text = `Your password reset code is: ${resetCode}`;

    try {
      await this.mailerService.sendMail({
        to: email,
        subject: subject,
        text: text,
        html: `<b>${text}</b>`, // HTML template version
      });
    } catch (error) {
      console.error('Error sending password reset email:', error);
      throw new Error('Error sending password reset email');
    }
  }

  // Send verification code email
  async SendVerificationCode(email: string, verifCode: string): Promise<void> {
    const subject = 'Email Verification';
    const text = `Your verification code is: ${verifCode}`;

    try {
      await this.mailerService.sendMail({
        to: email,
        subject: subject,
        text: text,
        html: `<b>${text}</b>`, // HTML version of the email content
      });
    } catch (error) {
      console.error('Error sending verification email:', error);
      throw new Error('Error sending verification email');
    }
  }
}
