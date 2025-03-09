import { Injectable } from '@nestjs/common';
import { UserLoginCommand } from "../../commands/user.loginCommand";
import { UserRepository } from "../../user.repository";
import { BcryptGateway } from "../../../../gateways/bcrypt.gateway";
import { UserErrors } from "../../../../../core/errors/UserErrors";
import { JwtGateway } from "../../../../gateways/jwt.gateway";
import { UserMail } from '../../../mail/usermail';



@Injectable()
export class UserLogin {
  constructor(
    private readonly userRepository: UserRepository, // User repository for finding users
    private readonly bcryptGateway: BcryptGateway, // For comparing passwords
    private readonly jwtGateway: JwtGateway, // JWT service for generating tokens
    private readonly userMail: UserMail,
    // Mail service for sending emails
  ) {}

  // Main logic for handling the login process
  async execute(email: string, resetCode_check: string): Promise<any> {

    // 1️⃣ Try finding user in UserRepository
    const user = await this.userRepository.findOneByEmail(email);

    // 2️⃣ If not found in UserRepository, check in PatientRepository

    // 3️⃣ If user (or patient) not found, throw error
    if (!user) {
      throw new UserErrors.WrongCredentials();
    }

    // 4️⃣ Verify the password or reset code (assuming you use a temporary password or verification code)
    // If the resetCode_check doesn't match the temporary code, throw error
    const isPasswordCorrect = await this.bcryptGateway.compare(resetCode_check, user.password || '');

    if (!isPasswordCorrect) {
      throw new UserErrors.WrongCredentials();
    }

    // 5️⃣ Generate and return JWT token with user or patient info
    const token = this.jwtGateway.generateToken({
      payload: {
        email: user.email,
        id: user.id,
      },
    });

    return token;
  }

  // Function to send a verification code via email
  async sendVerificationCode(email: string): Promise<{ message: string }> {
    const verificationCode = this.generateVerificationCode(); // Generate a random verification code

    // Send the verification code via email
    await this.userMail.SendVerificationCode(email, verificationCode);

    return {
      message: 'Verification code sent successfully.',
    };
  }

  // Function to generate a temporary verification code
  private generateVerificationCode(): string {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    const length = 6; // Verification code length

    for (let i = 0; i < length; i++) {
      result += characters.charAt(Math.floor(Math.random() * characters.length));
    }

    return result;
  }

  // Function to handle account verification with the reset code
  async accountVerification(loginCommand: UserLoginCommand): Promise<any> {
    // You can expand this to handle various verification steps if needed
    const user = await this.userRepository.findOneByEmail(loginCommand.email);
    if (!user) {
      throw new UserErrors.WrongCredentials();
    }

    // Proceed with verification logic, possibly sending an email
    await this.userMail.SendVerificationCode(user.email, 'your-verification-code-here');

    return { message: 'Account verified successfully.' };
  }
}
