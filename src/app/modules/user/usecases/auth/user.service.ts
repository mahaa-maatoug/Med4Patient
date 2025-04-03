import {  Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model} from 'mongoose';
import * as bcrypt from 'bcrypt';
import { User } from '../../user.entity';



import { randomBytes, createHash } from 'crypto';
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

  async requestPasswordReset(email: string): Promise<string> {
    const user = await this.userModel.findOne({ email });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    // Generate a reset token
    const resetToken = randomBytes(32).toString('hex');
    const hashedToken = createHash('sha256').update(resetToken).digest('hex');

    // Set reset token and expiration (1 hour)
    user.resetPasswordToken = hashedToken;
    user.resetPasswordExpires = new Date(Date.now() + 3600000);

    await user.save();

    // TODO: Send email with reset link
    return resetToken;
  }

  async resetPassword(token: string, newPassword: string): Promise<void> {
    const hashedToken = createHash('sha256').update(token).digest('hex');

    // Find user with valid token
    const user = await this.userModel.findOne({
      resetPasswordToken: hashedToken,
      resetPasswordExpires: { $gt: new Date() }, // Token must be valid
    });

    if (!user) {
      throw new NotFoundException('Invalid or expired token');
    }

    // Hash new password
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(newPassword, salt);

    // Clear reset token fields
    user.resetPasswordToken = null;
    user.resetPasswordExpires = null;

    await user.save();
  }
}

