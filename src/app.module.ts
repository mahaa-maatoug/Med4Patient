import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from './app/modules/user/user.module';
import { MongooseModule } from "@nestjs/mongoose";
import { HeaderResolver, I18nModule } from "nestjs-i18n";
import { join } from 'path';


import { ConfigModule, ConfigService } from '@nestjs/config';
import { MailerModule } from '@nestjs-modules/mailer';
import { MailModule } from 'src/app/modules/mail/MailModule';
import { patientmodule } from './app/modules/Patient/patientmodule';


@Module({
  imports: [
    // Load environment variables from the .env file
    ConfigModule.forRoot({
      envFilePath: '.env', // Point to your .env file
      isGlobal: true, // Makes the configuration available globally
    }),

    // MongoDB connection setup
    MongooseModule.forRoot(
      'mongodb+srv://nmseddi:x0OfWqwIJIpN2Q2V@maha.oo7bm.mongodb.net/med4?retryWrites=true&w=majority&appName=Maha'
    ),

    // Internationalization setup
    I18nModule.forRoot({
      fallbackLanguage: 'en',
      loaderOptions: {
        path: join(__dirname, '/core/i18n/'),
        watch: true,
      },
      resolvers: [new HeaderResolver(['x-lang'])],
    }),

    // Email configuration using environment variables
    MailerModule.forRootAsync({
      imports: undefined,
      useFactory: async (configService: ConfigService) => ({
        transport: {
          host: configService.get<string>('MAIL_HOST'), // Read from .env
          port: configService.get<number>('MAIL_PORT'), // Read from .env
          secure: false, // You can modify this for secure connections
          auth: {
            user: configService.get<string>('MAIL_USER'), // Read from .env
            pass: configService.get<string>('MAIL_PASS'), // Read from .env
          },
        },
        defaults: {
          from: configService.get<string>('MAIL_FROM'), // Default 'from' address
        },
      }),
      inject: [ConfigService] // Inject the ConfigService into useFactory
    }),

    // Your custom modules (like UserModule)
    UserModule,
    patientmodule,

    MailModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

