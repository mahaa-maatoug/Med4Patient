import { Injectable } from '@nestjs/common';
import { ValidationPipe, ValidationError } from '@nestjs/common';
import { HttpException, HttpStatus } from '@nestjs/common';
import { I18nService } from "nestjs-i18n";

@Injectable()
export class CustomValidationPipe extends ValidationPipe {

  constructor(
    private readonly i18nService : I18nService
  ) {
    super({
      exceptionFactory: (errors: ValidationError[]) => {
        const response = {
          statusCode: HttpStatus.BAD_REQUEST,
          message: i18nService.translate( "validation.INVALID_REQUEST_PARAMETERS"),
          errors: errors.map((error) => ({
            field: error.property,
            message: i18nService.translate(Object.values(error.constraints)[0]),
          })),
        };
        throw new HttpException(response, HttpStatus.BAD_REQUEST);
      },
    });
  }
}
