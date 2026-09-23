import { RoomSpaceType } from './catalog-types';
export interface RoomSpaceProps {
    type: RoomSpaceType;
    label: string;
    lengthM: number;
    widthM: number;
    capacityNotes?: string | null;
}
export declare class RoomSpace {
    readonly type: RoomSpaceType;
    readonly label: string;
    readonly lengthM: number;
    readonly widthM: number;
    readonly capacityNotes: string | null;
    private constructor();
    static create(props: RoomSpaceProps): RoomSpace;
    get areaM2(): number;
    copy(patch: Partial<RoomSpaceProps>): RoomSpace;
    toJSON(): Record<string, unknown>;
    static fromJSON(json: Record<string, unknown>): RoomSpace;
    equals(other: RoomSpace): boolean;
}
