import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { OrdonnanceService } from './ordonnance.service';

import { OrdonnanceRepository } from './ordonnance.repository';
import { Ordonnance, OrdonnanceSchema } from './Ordonnance.entity';
import { OrdonnanceController } from './ordonnance.controller';
import { OcrService } from './ocr.service';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Ordonnance.name, schema: OrdonnanceSchema }]),
  ],
  controllers: [OrdonnanceController],
  providers: [OrdonnanceService, OrdonnanceRepository, OcrService],
  exports: [OrdonnanceService, OrdonnanceRepository, OcrService],
})
export class OrdonnanceModule {}
