
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Order, OrderDocument } from './order.entity';

@Injectable()
export class OrderRepository {
  constructor(
    @InjectModel(Order.name)
    private readonly orderModel: Model<OrderDocument>,
  ) {}

  async create(data: Partial<Order>): Promise<Order> {
    return new this.orderModel(data).save();
  }

  async findByPatientId(patientId: string): Promise<Order[]> {
    return this.orderModel.find({ patientId }).exec();
  }

  async findById(id: string): Promise<Order> {
    return this.orderModel.findById(id).exec();
  }

  async updateStatus(id: string, status: string): Promise<Order> {
    return this.orderModel.findByIdAndUpdate(
      id,
      { status },
      { new: true }
    ).exec();
  }
}