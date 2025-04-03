import { Injectable } from '@nestjs/common';

import { Package } from './package.entity';
import { PackageRepository } from './package.repository';

;

@Injectable()
export class PackageService {
  constructor(private readonly packageRepository: PackageRepository) {}

  async getPackages(filters: any): Promise<Package[]> {
    return this.packageRepository.getPackages(filters);
  }

  async getPackageById(id: string): Promise<Package> {
    return this.packageRepository.getPackageById(id);
  }

  // Add any additional business logic here
  async getPackagesWithAddresses(filters: any): Promise<Package[]> {
    const packages = await this.getPackages(filters);
    return packages.filter(pkg => pkg.addresses && pkg.addresses.length > 0);
  }
}
