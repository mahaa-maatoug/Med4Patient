import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Ordonnance, OrdonnanceDocument } from './Ordonnance.entity';


@Injectable()
export class OrdonnanceRepository {
  constructor(@InjectModel(Ordonnance.name) private ordonnanceModel: Model<OrdonnanceDocument>) {}

  async create(data: Partial<Ordonnance>): Promise<Ordonnance> {
    const ordonnance = new this.ordonnanceModel(data);
    return ordonnance.save();
  }

  async findAll(): Promise<Ordonnance[]> {
    return this.ordonnanceModel.find().exec();
  }

  async findById(id: string): Promise<Ordonnance | null> {
    return this.ordonnanceModel.findById(id).exec();
  }

  async update(id: string, data: Partial<Ordonnance>): Promise<Ordonnance | null> {
    return this.ordonnanceModel.findByIdAndUpdate(id, data, { new: true }).exec();
  }

  async delete(id: string): Promise<void> {
    await this.ordonnanceModel.findByIdAndDelete(id).exec();
  }
  async findByDateRange(startDate: Date, endDate: Date): Promise<Ordonnance[]> {
    return this.ordonnanceModel.find({
      createdAt: {
        $gte: startDate,
        $lte: endDate
      }
    }).sort({ createdAt: -1 }).exec();
  }
}
