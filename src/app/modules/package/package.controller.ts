import { Controller, Get, Param, Query } from '@nestjs/common';
import { PackageService } from './package.service';
import { Package } from './package.entity';



@Controller('packages')
export class PackageController {
  constructor(private readonly packageService: PackageService) {}

  // Get all packages with filters
  @Get()
  async getPackages(@Query() filters: any): Promise<Package[]> {
    console.log('Received filters in controller:', filters); // Log filters received in controller
    try {
      const packages = await this.packageService.getPackages(filters);
      console.log('Packages found:', packages); // Log the packages fetched from the service
      return packages;
    } catch (error) {
      console.error('Error fetching packages:', error); // Log error if something goes wrong
      throw new Error('Error fetching packages');
    }
  }

  // Get package by ID
  @Get(':id')
  async getPackageById(@Param('id') id: string): Promise<Package> {
    console.log('Fetching package with ID:', id); // Log the ID being queried
    return this.packageService.getPackageById(id);
  }
}
