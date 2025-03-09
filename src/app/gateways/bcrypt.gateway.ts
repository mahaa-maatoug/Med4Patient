import {hash, compare} from "bcryptjs";
import { Injectable } from "@nestjs/common";

@Injectable()
export class BcryptGateway {
  async encrypt(password: string): Promise<string> {
    return hash(password, 10);
  }

  async compare(password: string, hash: string): Promise<boolean> {
    return compare(password, hash);

  }
}
