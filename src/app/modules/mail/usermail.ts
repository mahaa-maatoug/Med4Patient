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
  async SendResetPassword(email: string, resetCode: string): Promise<void> {
    const subject = 'Password Reset Request';
    const html = `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #1a5276;">Password Reset Request</h2>
        <p>Hello,</p>
        <p>We received a request to reset your password. Here is your verification code:</p>
        <div style="background: #f5f5f5; padding: 15px; margin: 20px 0; 
                    border-radius: 5px; font-size: 24px; font-weight: bold; 
                    color: #1a5276; text-align: center;">
          ${resetCode}
        </div>
        <p>This code will expire in 10 minutes.</p>
        <p>If you didn't request this, please ignore this email.</p>
        <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
        <p style="font-size: 12px; color: #777;">
          © ${new Date().getFullYear()} Your App Name. All rights reserved.
        </p>
      </div>
    `;

    try {
      await this.mailerService.sendMail({
        to: email,
        subject: subject,
        html: html,
      });
    } catch (error) {
      console.error('Error sending password reset email:', error);
      throw new Error('Failed to send password reset email');
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
