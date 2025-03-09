import { Module } from '@nestjs/common';
import { UserMail } from './usermail'; // Adjust the path as needed
import { MailerModule } from '@nestjs-modules/mailer';
import { ConfigModule, ConfigService } from '@nestjs/config';

@Module({
  imports: [
    MailerModule.forRootAsync({
      imports: [ConfigModule], // Import ConfigModule to use environment variables
      useFactory: async (configService: ConfigService) => ({
        transport: {
          host: configService.get<string>('MAIL_HOST'),
          port: configService.get<number>('MAIL_PORT'),
          secure: false, // Set to true if using SSL/TLS
          auth: {
            user: configService.get<string>('MAIL_USER'),
            pass: configService.get<string>('MAIL_PASS'),
          },
        },
        defaults: {
          from: configService.get<string>('MAIL_FROM'),
        },
      }),
      inject: [ConfigService], // Inject ConfigService into the factory
    }),
  ],
  providers: [UserMail], // Register UserMail as a provider
  exports: [UserMail], // Export UserMail so it can be used in other modules
})
export class MailModule {}
