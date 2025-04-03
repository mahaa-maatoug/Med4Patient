import { Injectable } from '@nestjs/common';

import { UserRepository } from "../../user.repository";
import { BcryptGateway } from "../../../../gateways/bcrypt.gateway";
import { UserErrors } from "../../../../../core/errors/UserErrors";
import { JwtGateway } from "../../../../gateways/jwt.gateway";

import { PatientRepository } from '../../../patient/patient.repository';

@Injectable()
export class UserLogin {
  constructor(
    private readonly userRepository: UserRepository, // User repository for finding users
    private readonly patientRepository: PatientRepository, // Patient repository for finding patients
    private readonly bcryptGateway: BcryptGateway, // For comparing passwords
    private readonly jwtGateway: JwtGateway, // JWT service for generating tokens

  ) {
  }


  async execute(email: string, password: string): Promise<any> {
    let user: any;


    // eslint-disable-next-line prefer-const
    user = await this.userRepository.findOneByEmail(email);

    // Log the user found (if any) after querying the patientRepository
    console.log('User found in patientRepository:', user);

    // 2️⃣ If user (patient) not found, throw error
    if (!user) {
      throw new UserErrors.WrongCredentials();
    }

    // 3️⃣ If no password field exists, use temporary password logic
    if (!user.password) {
      const temporaryPassword = 'password'; // Define the temporary password here

      if (password !== temporaryPassword) {
        throw new UserErrors.WrongCredentials();
      }
    } else {
      // If password exists, compare it using bcrypt
      const isPasswordCorrect = await this.bcryptGateway.compare(password, user.password);

      if (!isPasswordCorrect) {
        throw new UserErrors.WrongCredentials();
      }
    }

    // 4️⃣ Generate and return JWT token with user (patient) info
    const token = this.jwtGateway.generateToken({
      payload: {
        sub: user._id.toString(),  // MUST use 'sub' and ensure it's the MongoDB _id
        email: user.email,
        role: user.role
        // Include other needed claims
      },
    });

    return {
      token,
      user: {
        _id: user._id,  // Return proper ObjectId
        email: user.email,
        firstName: user.firstName,
      }
    };
  }
}
