import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from "@nestjs/common";
import { CustomValidationPipe } from "./core/pipes/CustomI18nValidationPipe";
import { I18nService } from "nestjs-i18n";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const i18n = app.get(I18nService);
  //@ts-ignore
  app.useGlobalPipes(new CustomValidationPipe(i18n));

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
