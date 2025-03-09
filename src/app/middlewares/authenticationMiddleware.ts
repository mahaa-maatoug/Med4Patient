import { Injectable, CanActivate, ExecutionContext, HttpStatus, HttpException } from "@nestjs/common";
import { Request } from "express";
import { JwtGateway } from "../gateways/jwt.gateway";
import { I18nService } from "nestjs-i18n";

@Injectable()
export class AuthenticationMiddleware implements CanActivate {
  constructor(
    private readonly jwtGateway: JwtGateway,
    private readonly i18nService: I18nService
  ) {
  }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<Request>();
    const authorization = request.header("Authorization");
    if (!authorization) {
      throw new HttpException(
        { message: this.i18nService.translate("errors.AUTHENTICATION_FAILED") },
        HttpStatus.FORBIDDEN
      );
    }
    // Extract the token
    const [, token] = authorization.split(" ");
    try {
      request["identity"] = await this.jwtGateway.verify(token);
      return true;
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
    } catch (e) {
      throw new HttpException(
        { message: this.i18nService.translate("errors.AUTHENTICATION_FAILED") },
        HttpStatus.FORBIDDEN
      );
    }
  }
}
