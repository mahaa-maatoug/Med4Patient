import { IsEmail, IsNotEmpty } from 'class-validator';


export class UserRegisterCommand {

  @IsEmail({}, { message: 'validation.EMAIL_INVALID' })
  @IsNotEmpty({ message: 'validation.EMAIL_REQUIRED' })
  email!: string;

  /**
   * Password for user
   *
   * @example abc@123
   * @type {string}
   */
  @IsNotEmpty({ message: 'validation.PASSWORD_REQUIRED' })
  password!: string;

  /**
   * Confirm password for user
   *
   * @example abc@123
   * @type {string}
   */
  @IsNotEmpty({ message: 'validation.CONFIRM_PASSWORD_REQUIRED' })
  confirmPassword!: string;

  /**
   * First name of user
   *
   * @example John
   * @type {string}
   */
  @IsNotEmpty({ message: 'validation.FIRST_NAME_REQUIRED' })
  firstName!: string;

  /**
   * Last name of user
   *
   * @example Doe
   * @type {string}
   */
  @IsNotEmpty({ message: 'validation.LAST_NAME_REQUIRED' })
  lastName!: string;

}
