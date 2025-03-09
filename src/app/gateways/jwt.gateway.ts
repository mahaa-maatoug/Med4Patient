import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { JwtService } from '@nestjs/jwt';
import { UserIdentity } from "../../core/models/UserIdentity";

interface GenerateTokenCommand{
  payload : any,
  expiresIn? : string
}
@Injectable()
export class JwtGateway extends PassportStrategy(Strategy) {
  constructor(
    private readonly jwtService: JwtService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: 'reallysecurekey',
    });
  }

  // Generate a JWT
  generateToken(cmd:GenerateTokenCommand): string {
    return this.jwtService.sign(cmd.payload,{
      expiresIn:cmd.expiresIn ?? '1y'
    });
  }

  // Generate JWT validity
  async verify(credential: string): Promise<UserIdentity> {
    const payload = this.jwtService.verify(credential, {
      secret:'reallysecurekey'
    }) as any;
    return {
      phone: payload.phone,
      email: payload.email,
      id: payload.id,
      role: payload.role,
    } as UserIdentity
  }


}
