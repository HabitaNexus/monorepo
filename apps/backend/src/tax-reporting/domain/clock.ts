/**
 * Reloj inyectable del módulo tributario (HAB-46).
 *
 * El cierre del período se prueba con un instante fijo. No se comparte el
 * reloj de negociación para no acoplar los dos dominios.
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
}
