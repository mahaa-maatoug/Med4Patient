import { IsEmail, IsNotEmpty } from 'class-validator';


export class UserLoginCommand {
  /**
   * Email of user
   *
   * @example jhonedoe@example.com
   * @type {string}
   */
  @IsEmail()
  @IsNotEmpty({ message: 'validation.EMAIL_REQUIRED' })
  email!: string;

  /**
   * Password for user
   *
   * @example abc@123
   * @type {string}
   */
  @IsNotEmpty({ message: 'validation.PASSWORD_REQUIRED' })
  password: string;
}
