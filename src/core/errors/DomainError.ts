export class DomainError extends Error {
  cause?: any;

  constructor(message?: string, cause?: any) {
    super(message);

    this.cause = cause;
  }
}
