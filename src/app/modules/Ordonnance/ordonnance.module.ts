import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { OrdonnanceService } from './ordonnance.service';

import { OrdonnanceRepository } from './ordonnance.repository';
import { Ordonnance, OrdonnanceSchema } from './Ordonnance.entity';
import { OrdonnanceController } from './ordonnance.controller';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Ordonnance.name, schema: OrdonnanceSchema }]),
  ],
  controllers: [OrdonnanceController],
  providers: [OrdonnanceService, OrdonnanceRepository],
  exports: [OrdonnanceService, OrdonnanceRepository],
})
export class OrdonnanceModule {}
