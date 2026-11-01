/**
 * Composición Nest del generador (HAB-31).
 *
 * Renderer y almacén en memoria. Sin controller y sin Prisma.
 */

import { Module } from '@nestjs/common';
import { InMemoryContractDocumentStore } from './infrastructure/persistence/in-memory-contract-document-store.js';
import { PdfLibRenderer } from './infrastructure/pdf/pdf-lib-renderer.js';
import { CONTRACT_DOCUMENT_STORE, PDF_RENDERER } from './contract.tokens.js';

@Module({
  providers: [
    { provide: PDF_RENDERER, useFactory: () => new PdfLibRenderer() },
    {
      provide: CONTRACT_DOCUMENT_STORE,
      useFactory: () => new InMemoryContractDocumentStore(),
    },
  ],
  exports: [PDF_RENDERER, CONTRACT_DOCUMENT_STORE],
})
export class ContractModule {}
