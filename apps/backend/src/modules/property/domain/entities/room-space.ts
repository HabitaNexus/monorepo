import { RoomSpaceType } from './catalog-types';

/**
 * Espacio individual de la distribución desglosada del inmueble.
 *
 * Espejo TypeScript de `RoomSpace` en mobile. Cada espacio declara sus
 * dimensiones en metros (largo × ancho); el área se deriva.
 * Obligatorio para dormitorios (SOP Fase 1), recomendado para el resto.
 */
export interface RoomSpaceProps {
  type: RoomSpaceType;
  label: string;
  lengthM: number;
  widthM: number;
  capacityNotes?: string | null;
}

export class RoomSpace {
  readonly type: RoomSpaceType;
  readonly label: string;
  readonly lengthM: number;
  readonly widthM: number;
  readonly capacityNotes: string | null;

  private constructor(props: Required<RoomSpaceProps>) {
    this.type = props.type;
    this.label = props.label;
    this.lengthM = props.lengthM;
    this.widthM = props.widthM;
    this.capacityNotes = props.capacityNotes;
    Object.freeze(this);
  }

  static create(props: RoomSpaceProps): RoomSpace {
    return new RoomSpace({
      capacityNotes: null,
      ...props,
    });
  }

  get areaM2(): number {
    return this.lengthM * this.widthM;
  }

  /** Equivalente a `copyWith` en mobile. */
  copy(patch: Partial<RoomSpaceProps>): RoomSpace {
    return RoomSpace.create({
      type: patch.type ?? this.type,
      label: patch.label ?? this.label,
      lengthM: patch.lengthM ?? this.lengthM,
      widthM: patch.widthM ?? this.widthM,
      capacityNotes: patch.capacityNotes ?? this.capacityNotes,
    });
  }

  toJSON(): Record<string, unknown> {
    return {
      type: this.type,
      label: this.label,
      length_m: this.lengthM,
      width_m: this.widthM,
      area_m2: this.areaM2,
      capacity_notes: this.capacityNotes,
    };
  }

  static fromJSON(json: Record<string, unknown>): RoomSpace {
    const type = json.type as RoomSpaceType;
    if (!Object.values(RoomSpaceType).includes(type)) {
      throw new Error(`Unknown RoomSpaceType: ${String(json.type)}`);
    }
    return RoomSpace.create({
      type,
      label: json.label as string,
      lengthM: (json.length_m as number) ?? 0,
      widthM: (json.width_m as number) ?? 0,
      capacityNotes: (json.capacity_notes as string | null) ?? null,
    });
  }

  equals(other: RoomSpace): boolean {
    return (
      this.type === other.type &&
      this.label === other.label &&
      this.lengthM === other.lengthM &&
      this.widthM === other.widthM &&
      this.capacityNotes === other.capacityNotes
    );
  }
}
