import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Package, PackageDocument } from './package.entity';



@Injectable()
export class PackageRepository {
  constructor(
    @InjectModel(Package.name) private readonly packageModel: Model<PackageDocument>,
  ) {}

  async getPackages(filters: any): Promise<Package[]> {
    console.log('Received filters:', filters);

    const query = this.packageModel.find(filters)
      .select('+addresses +originAddress');

    // Apply filters
    if (filters.status) {
      console.log('Applying filter for status:', filters.status);
      query.where('status').equals(filters.status);
    }

    if (filters.priority !== undefined) {
      console.log('Applying filter for priority:', filters.priority);
      query.where('priority').equals(filters.priority);
    }

    if (filters.deliveryDate) {
      console.log('Applying filter for deliveryDate:', filters.deliveryDate);
      query.where('deliveryDate').equals(filters.deliveryDate);
    }

    if (filters.receiverType) {
      console.log('Applying filter for receiverType:', filters.receiverType);
      query.where('receiverType').equals(filters.receiverType);
    }

    if (filters.isPicking !== undefined) {
      console.log('Applying filter for isPicking:', filters.isPicking);
      query.where('isPicking').equals(filters.isPicking);
    }

    try {
      const result = await query.exec();
      console.log('Packages found:', result.length);
      return result.map(doc => this.transformPackage(doc));
    } catch (error) {
      console.error('Error fetching packages:', error);
      throw new Error('Error fetching packages');
    }
  }

  async getPackageById(id: string): Promise<Package> {
    console.log('Fetching package with ID:', id);
    const result = await this.packageModel.findById(id)
      .select('+addresses +originAddress')
      .exec();

    if (!result) {
      throw new Error('Package not found');
    }

    return this.transformPackage(result);
  }

  private transformPackage(doc: PackageDocument): Package {
    const packageObj = doc.toObject({ versionKey: false });

    // Ensure groupReceiver is explicitly set to null if not defined
    if (packageObj.groupReceiver === undefined) {
      packageObj.groupReceiver = null;
    }

    return packageObj as Package;
  }
}