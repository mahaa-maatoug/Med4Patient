import {

  Body,
  Controller,
  Get,

  Post,
  Put,
  Req,
  Res,
  UseGuards,
} from '@nestjs/common';
import { Response } from 'express';
import { UserLogin } from "./usecases/auth/user.login";

import { I18n, I18nContext } from "nestjs-i18n";
import { UserRegister } from "./usecases/auth/user.register";
import { UserRegisterCommand } from "./commands/user.registerCommand";
import { UserErrors } from "../../../core/errors/UserErrors";
import { AuthenticationMiddleware } from "../../middlewares/authenticationMiddleware";
import { AuthenticatedRequest } from "../../config/authenticatedRequest";





import { UserService } from './usecases/auth/user.service';



import { ObjectId } from 'mongodb';
import { BcryptGateway } from '../../gateways/bcrypt.gateway';
import { UserRepository } from './user.repository';
import { UpdateUser } from './commands/user.updateCommand';


@Controller('/user')
export class UserController {
  constructor(
    private readonly userLogin: UserLogin,
    private readonly userRegister: UserRegister,
    private readonly bcryptGateway: BcryptGateway,private readonly userRepository: UserRepository,
    private readonly userService: UserService// Inject the patient repository here
  ) {}

  // Login route for patients
  @Post('/login')
  async login(
    @Res() res: Response,
    @Body() body: { email: string; password: string },
    @I18n() i18n: I18nContext
  ) {
    try {
      // 🔹 Capture both token and user from execute
      const { token, user } = await this.userLogin.execute(body.email, body.password);

      return res.status(200).json({
        token,
        user,
        message: i18n.translate('success.SUCCESSFULLY_LOGGED_IN'),
      });
    } catch (e) {
      if (e instanceof UserErrors.WrongCredentials) {
        return res.status(401).json({ message: i18n.translate('errors.WRONG_CREDENTIALS') });
      }
      return res.status(401).json({ message: i18n.translate('errors.AUTHENTICATION_FAILED') });
    }
  }





  // Register route for new users or patients
  @Post('/register')
  async register(
    @Res() res: Response,
    @Body() body: UserRegisterCommand,
    @I18n() i18n: I18nContext
  ) {
    try {
      await this.userRegister.execute(body); // Register the user or patient
      return res.status(201).json({
        success: true,
        message: i18n.translate('success.SUCCESSFULLY_REGISTERED'), // Success message after registration
      });
    } catch (e) {
      // Handle various registration errors
      if (e instanceof UserErrors.EmailAlreadyUsed)
        return res.status(403).json({ message: i18n.translate('errors.EMAIL_ALREADY_USED') });
      if (e instanceof UserErrors.PasswordInvalid)
        return res.status(403).json({ message: i18n.translate('errors.PASSWORD_INVALID') });
      if (e instanceof UserErrors.ProfileAlreadyUsed)
        return res.status(403).json({ message: i18n.translate('errors.PROFILE_ALREADY_USED') });
      return res.status(403).json({ message: i18n.translate('errors.AUTHENTICATION_FAILED') });
    }
  }
  @UseGuards(AuthenticationMiddleware)
  @Put('/profile')
  async updateProfile(
    @Body() updateData: UpdateUser, // Use the DTO
    @Req() req: AuthenticatedRequest,
    @Res() res: Response,
    @I18n() i18n: I18nContext
  ) {
    try {
      const userId = req.identity._id.toString();

      // 1. Handle password separately
      if (updateData.password) {
        await this.userService.changePassword({
          userId: new ObjectId(userId),
          newPassword: updateData.password
        });
      }

      // 2. Prepare safe update object
      const { password, ...safeUpdate } = updateData as any;

      if (password) {
        (safeUpdate as any).password = await this.bcryptGateway.encrypt(password);
      }
      // 3. Perform the update
      const updatedUser = await this.userService.updateUser(userId, safeUpdate);

      if (!updatedUser) {
        throw new UserErrors.UserNotFound();
      }

      return res.json({
        success: true,
        user: {
          firstName: updatedUser.firstName,
          lastName: updatedUser.lastName,
          password:updatedUser.password,
          // Don't return sensitive data
        }
      });

    } catch (e) {
      console.error('Update failed:', e); // Add logging
      return res.status(500).json({
        message: i18n.translate('errors.PROFILE_UPDATE_FAILED')
      });
    }
  }

// Route to get the currently authenticated user's information (protected by authentication guard)
  @Get('me')
  @UseGuards(AuthenticationMiddleware) // Protect with the AuthenticationMiddleware guard
  async getMe(
    @Req() req: AuthenticatedRequest,
    @Res() res: Response,
    @I18n() i18n: I18nContext
  ) {
    try {
      // Return the authenticated user's data
      return res.status(200).json(req.identity);
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
    } catch (e) {
      return res.status(403).json({ message: i18n.translate('errors.AUTHENTICATION_FAILED') });
    }
  }
  @Post('/forgot-password')
  async forgotPassword(@Body('email') email: string) {
    const token = await this.userService.requestPasswordReset(email);


    return { message: 'Reset link sent to your email', token };
  }

  @Put('/reset-password')
  async resetPassword(
    @Body('token') token: string,
    @Body('newPassword') newPassword: string,
  ) {
    await this.userService.resetPassword(token, newPassword);
    return { message: 'Password reset successfully' };
  }


// In UserController
  @Post('/emergency-repair-password')
  async emergencyRepairPassword(
    @Body() body: { email: string },
    @Res() res: Response
  ) {
    try {
      const user = await this.userRepository.findOneByEmail(body.email);
      if (!user) throw new UserErrors.UserNotFound();

      // Re-encrypt if password exists and isn't already hashed
      if (user.password && !user.password.startsWith('$2a$')) {
        user.password = await this.bcryptGateway.encrypt(user.password);
        await user.save();
        return res.json({ success: true, message: 'Password fixed' });
      }

      return res.json({ success: false, message: 'Password already encrypted or missing' });
    } catch  {
      return res.status(500).json({ message: 'Repair failed' });
    }
  }

}
