import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './user.entity';
import { ObjectId } from 'mongodb';
import { BcryptGateway } from '../../gateways/bcrypt.gateway';
import { UserErrors } from '../../../core/errors/UserErrors';




@Injectable()
export class UserRepository {
  constructor(
    @InjectModel('User') private readonly userModel: Model<User>,
    private readonly bcryptGateway: BcryptGateway,
  ) {}

  async findOneById(id: ObjectId): Promise<User | null> {
    return this.userModel.findOne({ _id: id }).exec();
  }

  async findOneByEmail(email: string): Promise<User | null> {
    return this.userModel.findOne({ email }).exec();
  }

  async save(userData: Partial<User>): Promise<User> {
    if (userData.password) {
      userData.password = await this.bcryptGateway.encrypt(userData.password);
    }
    return this.userModel.create(userData);
  }
  async findById(userId: string): Promise<User | null> {
    const objectId = new ObjectId(userId);
    return this.userModel.findById(objectId).exec();
  }
  async updateUser(userId: string, updateData: Partial<User>): Promise<User | null> {
    try {
      // Check if email is being updated and if it's already in use
      if (updateData.email) {
        const existingUser = await this.userModel.findOne({ email: updateData.email });
        if (existingUser && existingUser._id.toString() !== userId) {
          throw new UserErrors.EmailAlreadyUsed();
        }
      }

      const objectId = new ObjectId(userId);
      return this.userModel.findByIdAndUpdate(
        objectId,
        updateData,
        { new: true, runValidators: true }
      ).exec();
    } catch (error) {
      if (error instanceof Error && error.message.includes('ObjectId')) {
        throw new Error('Invalid user ID format');
      }
      throw error;
    }
  }

  async delete(id: ObjectId): Promise<boolean> {
    const result = await this.userModel.deleteOne({ _id: id }).exec();
    return result.deletedCount > 0;
  }

  async changePassword(
    id: ObjectId,
    currentPassword: string,
    newPassword: string,
  ): Promise<void> {
    const user = await this.userModel.findById(id).exec();
    if (!user) {
      throw new UserErrors.UserNotFound();
    }

    const isMatch = await this.bcryptGateway.compare(
      currentPassword,
      user.password,
    );
    if (!isMatch) {
      throw new UserErrors.WrongCredentials();
    }

    user.password = await this.bcryptGateway.encrypt(newPassword);
    await user.save();
  }

  // Utility method to convert string to ObjectId
  static toObjectId(id: string | ObjectId): ObjectId {
    return id instanceof ObjectId ? id : new ObjectId(id);
  }
}
