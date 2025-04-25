import {  Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model} from 'mongoose';

import { User } from '../../user.entity';




import { UserRepository } from '../../user.repository';
import { BcryptGateway } from '../../../../gateways/bcrypt.gateway';
import { ObjectId } from 'mongodb';
import { UserErrors } from '../../../../../core/errors/UserErrors';




@Injectable()
export class UserService {
  constructor(@InjectModel(User.name) private userModel: Model<User>, private readonly bcryptGateway: BcryptGateway,private readonly userRepository: UserRepository) {}

  async changePassword(
    { userId, newPassword }: { userId: ObjectId, newPassword: string }
  ): Promise<void> {
    const user = await this.userModel.findById(userId).exec();
    if (!user) {
      throw new UserErrors.UserNotFound();
    }

    user.password = await this.bcryptGateway.encrypt(newPassword);
    await user.save();
  }
  async updateUser(userId: string, updateData: Partial<User>): Promise<User | null> {
    // Handle password encryption if password is being updated
    if (updateData.password) {
      updateData.password = await this.bcryptGateway.encrypt(updateData.password);
    }

    return this.userRepository.updateUser(userId, updateData);
  }


}

