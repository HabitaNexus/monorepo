/**
 * Aviso de declaración enviada (HAB-46).
 *
 * El canal todavía no existe. Este adaptador solo deja el hecho en el log
 * del proceso cuando el sender real devuelva submitted.
 */

import { Injectable } from '@nestjs/common';
import type {
  DeclarationNotice,
  OwnerNotificationPort,
} from '../application/owner-notification.js';

@Injectable()
export class LoggingOwnerNotifier implements OwnerNotificationPort {
  async notifyDeclarationSubmitted(notice: DeclarationNotice): Promise<void> {
    console.info(
      `tax-declaration-submitted owner=${notice.ownerId} period=${notice.period}`,
    );
  }
}
