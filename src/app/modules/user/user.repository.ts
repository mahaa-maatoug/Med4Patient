import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './user.entity';

@Injectable()
export class UserRepository {
  constructor(@InjectModel('User') private readonly userModel: Model<User>) {}

  async findOneById(id: string): Promise<User | null> {
    return this.userModel.findById(id).exec();
  }

  async findOneByEmail(email: string): Promise<User | null> {
    return this.userModel.findOne({ email }).exec();
  }

  async save(userData: Partial<User>): Promise<User> {
    return await this.userModel.create(userData);
  }

  // Update a user
  async update(id: string, updateData: Partial<User>): Promise<User | null> {
    return this.userModel.findByIdAndUpdate(id, updateData, { new: true }).exec();
  }

  async delete(id: string): Promise<boolean> {
    const result = await this.userModel.deleteOne({ id }).exec();
    return result.deletedCount > 0;
  }
}
