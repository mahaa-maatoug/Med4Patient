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
  @Get('/profile')
  async getProfile(
    @Req() req: AuthenticatedRequest,
    @Res() res: Response,
    @I18n() i18n: I18nContext
  ) {
    try {
      const userId = req.identity._id;
      const user = await this.userRepository.findOneById(userId);

      if (!user) {
        return res.status(404).json({ message: i18n.translate('errors.USER_NOT_FOUND') });
      }

      return res.status(200).json({
        user: {
          id: user._id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          role: user.role
        }
      });
    } catch  {
      return res.status(500).json({ message: i18n.translate('errors.SERVER_ERROR') });
    }
  }

  @UseGuards(AuthenticationMiddleware)
  @Put('/profile')
  async updateProfile(
    @Req() req: AuthenticatedRequest,
    @Res() res: Response,
    @Body() body: UpdateUser,
    @I18n() i18n: I18nContext
  ) {
    try {
      const userId = req.identity._id;

      // If password is being updated, encrypt it
      if (body.password) {
        body.password = await this.bcryptGateway.encrypt(body.password);
      }

      const updatedUser = await this.userRepository.updateUser(userId.toString(), body);

      if (!updatedUser) {
        return res.status(404).json({ message: i18n.translate('errors.USER_NOT_FOUND') });
      }

      return res.status(200).json({
        user: {
          id: updatedUser._id,
          firstName: updatedUser.firstName,
          lastName: updatedUser.lastName,
          email: updatedUser.email
        },
        message: i18n.translate('success.PROFILE_UPDATED')
      });
    } catch (e) {
      if (e instanceof UserErrors.EmailAlreadyUsed) {
        return res.status(400).json({ message: i18n.translate('errors.EMAIL_ALREADY_USED') });
      }
      return res.status(500).json({ message: i18n.translate('errors.SERVER_ERROR') });
    }
  }

  @UseGuards(AuthenticationMiddleware)
  @Put('/change-password')
  async changePassword(
    @Req() req: AuthenticatedRequest,
    @Res() res: Response,
    @Body() body: { currentPassword: string; newPassword: string },
    @I18n() i18n: I18nContext
  ) {
    try {
      console.log('Change password request received'); // Debug log
      console.log('User identity:', req.identity); // Debug log

      // Ensure identity exists
      if (!req.identity) {
        console.log('No identity in request');
        return res.status(401).json({ message: 'Unauthorized' });
      }

      // Convert string ID to ObjectId if needed
      const userId = req.identity._id;
      console.log('User ID:', userId); // Debug log

      await this.userRepository.changePassword(
        userId,
        body.currentPassword,
        body.newPassword
      );

      return res.status(200).json({
        message: i18n.t('success.PASSWORD_CHANGED')
      });
    } catch (e) {
      console.error('Error changing password:', e); // Debug log

      if (e instanceof UserErrors.WrongCredentials) {
        return res.status(401).json({ message: i18n.t('errors.WRONG_CURRENT_PASSWORD') });
      }
      if (e instanceof UserErrors.UserNotFound) {
        return res.status(404).json({ message: i18n.t('errors.USER_NOT_FOUND') });
      }

      // More specific error handling
      if (e instanceof Error && e.message.includes('ObjectId')) {
        return res.status(400).json({ message: 'Invalid user ID format' });
      }

      return res.status(500).json({
        message: i18n.t('errors.SERVER_ERROR'),
        error: process.env.NODE_ENV === 'development' ? e.message : undefined
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
