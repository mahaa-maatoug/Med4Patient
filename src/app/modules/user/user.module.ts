
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

@Module({
  imports: [
    MongooseModule.forFeature([{ name: "User", schema: UserSchema }]),
    JwtModule.register({
      secret: "reallysecurekey",
      signOptions: { expiresIn: "1y" }
    })
  ],
  controllers: [UserController],
  providers: [
    UserRegister,
    UserRepository,
    BcryptGateway,
    JwtGateway,
    UserMail,
    UserLogin,
    AuthenticationMiddleware
  ]
})
export class UserModule {
}
