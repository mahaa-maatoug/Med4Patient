import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { PackageService } from './package.service';
import { PackageController } from './package.controller';
import { Package, PackageSchema } from './package.entity';
import { PackageRepository } from './package.repository';

@Module({
  imports: [MongooseModule.forFeature([{ name: Package.name, schema: PackageSchema }])],
  controllers: [PackageController],
  providers: [PackageService, PackageRepository],
})
export class PackageModule {}
