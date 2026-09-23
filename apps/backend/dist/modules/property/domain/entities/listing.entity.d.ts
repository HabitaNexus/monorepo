import { ListingStatus } from './catalog-types';
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
export declare class Listing {
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
    private constructor();
    static create(props: ListingProps): Listing;
    copy(patch: Partial<ListingProps>): Listing;
    toJSON(): Record<string, unknown>;
    static fromJSON(json: Record<string, unknown>): Listing;
    equals(other: Listing): boolean;
}
