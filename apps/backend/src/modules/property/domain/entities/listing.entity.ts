import { ListingStatus } from './catalog-types';

/**
 * Publicación activa de un `Property` (fase 1, paso 3 + fase 2).
 *
 * Espejo TypeScript de `Listing` en mobile, mismo contrato JSON.
 * Precio publicado, rangos negociables (precio mínimo, duración
 * mínima/máxima, depósito) y condiciones no negociables. El estado
 * controla la visibilidad en descubrimiento.
 * Capa domain: sin dependencias de NestJS ni de infrastructure.
 */
export interface ListingProps {
  id: string;
  propertyId: string;
  monthlyRent: number;
  minRent?: number | null;
  depositAmount: number;
  minDurationMonths?: number | null;
  maxDurationMonths?: number | null;
  nonNegotiableConditions?: string[];
  status: ListingStatus;
  publishedAt?: Date | null;
  createdAt?: Date | null;
  updatedAt?: Date | null;
}

const NULL_DEFAULT: null = null;

export class Listing {
  readonly id: string;
  readonly propertyId: string;
  readonly monthlyRent: number;
  readonly minRent: number | null;
  readonly depositAmount: number;
  readonly minDurationMonths: number | null;
  readonly maxDurationMonths: number | null;
  readonly nonNegotiableConditions: readonly string[];
  readonly status: ListingStatus;
  readonly publishedAt: Date | null;
  readonly createdAt: Date | null;
  readonly updatedAt: Date | null;

  private constructor(props: ListingProps) {
    this.id = props.id;
    this.propertyId = props.propertyId;
    this.monthlyRent = props.monthlyRent;
    this.minRent = props.minRent ?? NULL_DEFAULT;
    this.depositAmount = props.depositAmount;
    this.minDurationMonths = props.minDurationMonths ?? NULL_DEFAULT;
    this.maxDurationMonths = props.maxDurationMonths ?? NULL_DEFAULT;
    this.nonNegotiableConditions = Object.freeze([
      ...(props.nonNegotiableConditions ?? []),
    ]);
    this.status = props.status;
    this.publishedAt = props.publishedAt ?? NULL_DEFAULT;
    this.createdAt = props.createdAt ?? NULL_DEFAULT;
    this.updatedAt = props.updatedAt ?? NULL_DEFAULT;
    Object.freeze(this);
  }

  static create(props: ListingProps): Listing {
    return new Listing(props);
  }

  /** Equivalente a `copyWith` en mobile. */
  copy(patch: Partial<ListingProps>): Listing {
    return Listing.create({
      id: patch.id ?? this.id,
      propertyId: patch.propertyId ?? this.propertyId,
      monthlyRent: patch.monthlyRent ?? this.monthlyRent,
      minRent: patch.minRent ?? this.minRent,
      depositAmount: patch.depositAmount ?? this.depositAmount,
      minDurationMonths: patch.minDurationMonths ?? this.minDurationMonths,
      maxDurationMonths: patch.maxDurationMonths ?? this.maxDurationMonths,
      nonNegotiableConditions: patch.nonNegotiableConditions
        ? [...patch.nonNegotiableConditions]
        : [...this.nonNegotiableConditions],
      status: patch.status ?? this.status,
      publishedAt: patch.publishedAt ?? this.publishedAt,
      createdAt: patch.createdAt ?? this.createdAt,
      updatedAt: patch.updatedAt ?? this.updatedAt,
    });
  }

  toJSON(): Record<string, unknown> {
    return {
      id: this.id,
      property_id: this.propertyId,
      monthly_rent: this.monthlyRent,
      min_rent: this.minRent,
      deposit_amount: this.depositAmount,
      min_duration_months: this.minDurationMonths,
      max_duration_months: this.maxDurationMonths,
      non_negotiable_conditions: [...this.nonNegotiableConditions],
      status: this.status,
      published_at: this.publishedAt ? this.publishedAt.toISOString() : null,
      created_at: this.createdAt ? this.createdAt.toISOString() : null,
      updated_at: this.updatedAt ? this.updatedAt.toISOString() : null,
    };
  }

  static fromJSON(json: Record<string, unknown>): Listing {
    const parseDate = (raw: unknown): Date | null => {
      if (raw === null || raw === undefined) return null;
      return new Date(raw as string);
    };
    const status = json.status as ListingStatus;
    if (!Object.values(ListingStatus).includes(status)) {
      throw new Error(`Unknown status: ${String(json.status)}`);
    }
    return Listing.create({
      id: json.id as string,
      propertyId: json.property_id as string,
      monthlyRent: json.monthly_rent as number,
      minRent: (json.min_rent as number | null) ?? null,
      depositAmount: json.deposit_amount as number,
      minDurationMonths: (json.min_duration_months as number | null) ?? null,
      maxDurationMonths: (json.max_duration_months as number | null) ?? null,
      nonNegotiableConditions: (
        (json.non_negotiable_conditions as string[] | null) ?? []
      ).slice(),
      status,
      publishedAt: parseDate(json.published_at),
      createdAt: parseDate(json.created_at),
      updatedAt: parseDate(json.updated_at),
    });
  }

  equals(other: Listing): boolean {
    return JSON.stringify(this.toJSON()) === JSON.stringify(other.toJSON());
  }
}
