import { Injectable } from '@nestjs/common';
import { UserRepository } from "../../user.repository";
import { UserErrors } from "../../../../../core/errors/UserErrors";
import { UserRegisterCommand } from "../../commands/user.registerCommand";
import { Usecase } from "../../../../../core/models/usecase";
import { BcryptGateway } from "../../../../gateways/bcrypt.gateway";
import { v4 } from "uuid";
import { UserIdentity } from "../../../../../core/models/UserIdentity";

@Injectable()
export class UserRegister implements Usecase<UserRegisterCommand, boolean>{
  constructor(
    private userRepository: UserRepository,
    private bcryptGateway: BcryptGateway
  ) {}

  async execute(registerCommand: UserRegisterCommand): Promise<any> {
    //check user existence
    const user = await this.userRepository.findOneByEmail(registerCommand.email);
    if (user) {
      throw new UserErrors.EmailAlreadyUsed;
    }
    //check passwords match
    if(registerCommand.password!==registerCommand.confirmPassword){
      throw new UserErrors.PasswordInvalid
    }
    //save user
    const userSaved=await this.userRepository.save({
      id: v4(),
      email:registerCommand.email,
      password:await this.bcryptGateway.encrypt(registerCommand.password),
      fistName:registerCommand.firstName,
      lastName:registerCommand.lastName
    })
    //return true if saved
    return !!userSaved;
  }
}
