/**
 * Puerto de aviso al propietario (HAB-46).
 *
 * Solo se llama cuando el sender devuelve submitted. El canal (correo, push)
 * no se elige aquí.
 */

export interface DeclarationNotice {
  readonly ownerId: string;
  readonly period: string;
}

export interface OwnerNotificationPort {
  notifyDeclarationSubmitted(notice: DeclarationNotice): Promise<void>;
}
