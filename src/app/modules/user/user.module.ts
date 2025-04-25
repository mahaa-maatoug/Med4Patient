
import { Module } from '@nestjs/common';
import { UserLogin } from "./usecases/auth/user.login";
import { MongooseModule } from "@nestjs/mongoose";
import { UserSchema } from "./user.entity";
import { UserController } from "./user.controller";
import { JwtModule } from "@nestjs/jwt";
import { UserRepository } from "./user.repository";
import { UserRegister } from "./usecases/auth/user.register";
import { BcryptGateway } from "../../gateways/bcrypt.gateway";
import { JwtGateway } from "../../gateways/jwt.gateway";
import { AuthenticationMiddleware } from "../../middlewares/authenticationMiddleware";
import { UserMail } from '../mail/usermail';
import { PatientModule } from '../patient/patient.module';
import { UserService } from './usecases/auth/user.service';
import { ResetPasswordController } from './reset-password.controller';
import { ResetPasswordService } from './reset-password.service';


@Module({
  imports: [
    PatientModule,
    MongooseModule.forFeature([{ name: "User", schema: UserSchema }]),
    JwtModule.register({
      secret: "reallysecurekey",
      signOptions: { expiresIn: "1y" }
    })
  ],
  controllers: [UserController,ResetPasswordController],
  providers: [
    UserRegister,
    UserRepository,
    BcryptGateway,
    JwtGateway,
    UserMail,
    UserLogin,
    AuthenticationMiddleware,
    UserService,
    ResetPasswordService
  ],
  exports: [JwtGateway],
})
export class UserModule {
}
