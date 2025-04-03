import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

import { CustomValidationPipe } from "./core/pipes/CustomI18nValidationPipe";
import { I18nService } from "nestjs-i18n";
import { join } from 'path';
import * as express from 'express';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const i18n = app.get(I18nService);
  //@ts-ignore
  app.useGlobalPipes(new CustomValidationPipe(i18n));
  app.use('/uploads', express.static(join(__dirname, '..', 'uploads')));

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();