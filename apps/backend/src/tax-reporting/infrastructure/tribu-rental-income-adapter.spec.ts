import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { TaxReportingOperationOutOfScope } from '../domain/errors.js';
import { InMemoryRentalIncomeLedger } from './persistence/in-memory-rental-income-ledger.js';
import { TribuRentalIncomeAdapter } from './tribu-rental-income-adapter.js';

describe('TribuRentalIncomeAdapter (HAB-46)', () => {
  const adapter = new TribuRentalIncomeAdapter(new InMemoryRentalIncomeLedger());

  it('rechaza la factura electrónica y el estado de cumplimiento', async () => {
    await expect(adapter.generateElectronicInvoice({ paymentId: 'pay-1' })).rejects.toBeInstanceOf(
      TaxReportingOperationOutOfScope,
    );
    await expect(adapter.checkComplianceStatus('owner-1')).rejects.toBeInstanceOf(
      TaxReportingOperationOutOfScope,
    );
  });

  it('no importa un cliente gRPC', () => {
    const source = readFileSync(
      join(process.cwd(), 'src/tax-reporting/infrastructure/tribu-rental-income-adapter.ts'),
      'utf8',
    );
    expect(source).not.toContain('@grpc/grpc-js');
    expect(source).toContain('GetAuthStatus');
    expect(source).toContain('GetAccessToken');
    expect(source).toContain('presentation-rpc-not-in-hacienda-auth-proto');
  });
});
