import { calculateRentalIncomeTax } from './rental-income-tax.js';

describe('calculateRentalIncomeTax (HAB-46)', () => {
  it('taxes 500000 at 15 percent of 85 percent with no IVA', () => {
    expect(calculateRentalIncomeTax(500_000n)).toEqual({
      taxableBaseCrc: 425_000n,
      incomeTaxCrc: 63_750n,
      ivaCrc: 0n,
    });
  });

  it('adds 13 percent IVA on an 800000 gross', () => {
    expect(calculateRentalIncomeTax(800_000n)).toEqual({
      taxableBaseCrc: 680_000n,
      incomeTaxCrc: 102_000n,
      ivaCrc: 104_000n,
    });
  });

  it('charges no IVA at exactly 693300', () => {
    expect(calculateRentalIncomeTax(693_300n)).toEqual({
      taxableBaseCrc: 589_305n,
      incomeTaxCrc: 88_396n,
      ivaCrc: 0n,
    });
  });
});
