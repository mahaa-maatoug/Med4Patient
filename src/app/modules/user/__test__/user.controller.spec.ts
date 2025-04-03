import { Test, TestingModule } from '@nestjs/testing';
import { I18nContext } from 'nestjs-i18n';
import { Response } from 'express';
import { UserController } from "../user.controller";
import { UserLogin } from "../usecases/auth/user.login";
import { UserRegister } from "../usecases/auth/user.register";
import { UserLoginCommand } from "../commands/user.loginCommand";
import { UserRegisterCommand } from "../commands/user.registerCommand";
import { UserErrors } from "../../../../core/errors/UserErrors";

describe('UserController', () => {
  let userController: UserController;
  let userLogin: UserLogin;
  let userRegister: UserRegister;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UserController],
      providers: [
        { provide: UserLogin, useValue: { execute: jest.fn() } },
        { provide: UserRegister, useValue: { execute: jest.fn() } },
      ],
    }).compile();

    userController = module.get<UserController>(UserController);
    userLogin = module.get<UserLogin>(UserLogin);
    userRegister = module.get<UserRegister>(UserRegister);
  });

  describe('login', () => {
    it('should execute userLogin with UserLoginCommand', async () => {
      const body: UserLoginCommand = new UserLoginCommand();
      await userController.login(body);
      expect(userLogin.execute).toHaveBeenCalledWith(body);
    });

    it('should handle exceptions during login', async () => {
      const body: UserLoginCommand = new UserLoginCommand();
      jest.spyOn(userLogin, 'execute').mockImplementation(() => { throw new Error('login error'); });
      const result = await userController.login(body);
      expect(result).toEqual({ message: 'Error while user login: Error: login error' });
    });
  });

  describe('register', () => {
    it('should execute userRegister with UserRegisterCommand', async () => {
      const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn(),
      } as unknown as Response;
      const body: UserRegisterCommand = new UserRegisterCommand();
      const i18n: I18nContext = {} as I18nContext;
      await userController.register(res, body, i18n);
      expect(userRegister.execute).toHaveBeenCalledWith(body);
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith({
        success: true,
        message: 'User successfully registered',
      });
    });

    it('should handle EmailAlreadyUsed error during registration', async () => {
      const res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn(),
      } as unknown as Response;
      const body: UserRegisterCommand = new UserRegisterCommand();
      const i18n: I18nContext = { translate: jest.fn().mockReturnValue('Email already used') } as unknown as I18nContext;
      jest.spyOn(userRegister, 'execute').mockImplementation(() => { throw new UserErrors.EmailAlreadyUsed(); });
      await userController.register(res, body, i18n);
      expect(res.status).toHaveBeenCalledWith(403);
      expect(res.json).toHaveBeenCalledWith({ message: 'Email already used' });
    });

    // Add similar test cases for other errors: PasswordInvalid, ProfileAlreadyUsed, etc.
  });
});
