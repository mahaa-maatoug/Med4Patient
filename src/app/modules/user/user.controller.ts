import { Body, Controller, Get, Post, Req, Res, UseGuards } from "@nestjs/common";
import { Response } from 'express';
import { UserLogin } from "./usecases/auth/user.login";
import { UserLoginCommand } from "./commands/user.loginCommand";
import { I18n, I18nContext } from "nestjs-i18n";
import { UserRegister } from "./usecases/auth/user.register";
import { UserRegisterCommand } from "./commands/user.registerCommand";
import { UserErrors } from "../../../core/errors/UserErrors";
import { AuthenticationMiddleware } from "../../middlewares/authenticationMiddleware";
import { AuthenticatedRequest } from "../../config/authenticatedRequest";

@Controller('/user')
export class UserController {
  constructor(
    private readonly userLogin: UserLogin,
    private readonly userRegister: UserRegister
  ) {}

  // Login route for patients
  @Post('/login')
  async login(
    @Res() res: Response,
    @Body() body: UserLoginCommand,
    @I18n() i18n: I18nContext
  ) {
    try {
      // Try logging in the user (it could be a patient or a user)
      const token: string = await this.userLogin.execute(body.email, body.resetCode_check);

      return res.status(200).json({
        token,
        message: i18n.translate('success.SUCCESSFULLY_LOGGED_IN'), // Success message
      });
    } catch (e) {
      console.log(e);
      if (e instanceof UserErrors.WrongCredentials) {
        return res.status(401).json({ message: i18n.translate('errors.WRONG_CREDENTIALS') }); // Error if credentials are wrong
      }
      return res.status(401).json({ message: i18n.translate('errors.AUTHENTICATION_FAILED') }); // General authentication failure
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
}
