/**
 * Puerto de tiempo inyectable (HAB-26).
 *
 * Producción usa `SystemClock`; los tests usan `FixedClock` para
 * expiraciones deterministas. Dominio puro.
 */

export interface Clock {
  now(): Date;
}

export class SystemClock implements Clock {
  now(): Date {
    return new Date();
  }
}

export class FixedClock implements Clock {
  private current: Date;

  constructor(initial: Date | string) {
    this.current = new Date(initial);
  }

  now(): Date {
    return new Date(this.current);
  }

  advanceByHours(hours: number): void {
    this.current = new Date(this.current.getTime() + hours * 3_600_000);
  }

  setTo(instant: Date | string): void {
    this.current = new Date(instant);
  }
}
