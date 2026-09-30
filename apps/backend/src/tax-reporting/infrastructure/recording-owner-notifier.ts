/**
 * Notificador de tests (HAB-46).
 *
 * Guarda los avisos en memoria. No importa Nest para que Jest no cargue
 * el ESM de `@nestjs/common`.
 */

import type {
  DeclarationNotice,
  OwnerNotificationPort,
} from '../application/owner-notification.js';

export class RecordingOwnerNotifier implements OwnerNotificationPort {
  readonly notices: DeclarationNotice[] = [];

  async notifyDeclarationSubmitted(notice: DeclarationNotice): Promise<void> {
    this.notices.push(notice);
  }
}
