"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Listing = void 0;
const catalog_types_1 = require("./catalog-types");
const NULL_DEFAULT = null;
class Listing {
    id;
    propertyId;
    monthlyRent;
    minRent;
    depositAmount;
    minDurationMonths;
    maxDurationMonths;
    nonNegotiableConditions;
    status;
    publishedAt;
    createdAt;
    updatedAt;
    constructor(props) {
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
    static create(props) {
        return new Listing(props);
    }
    copy(patch) {
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
    toJSON() {
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
    static fromJSON(json) {
        const parseDate = (raw) => {
            if (raw === null || raw === undefined)
                return null;
            return new Date(raw);
        };
        const status = json.status;
        if (!Object.values(catalog_types_1.ListingStatus).includes(status)) {
            throw new Error(`Unknown status: ${String(json.status)}`);
        }
        return Listing.create({
            id: json.id,
            propertyId: json.property_id,
            monthlyRent: json.monthly_rent,
            minRent: json.min_rent ?? null,
            depositAmount: json.deposit_amount,
            minDurationMonths: json.min_duration_months ?? null,
            maxDurationMonths: json.max_duration_months ?? null,
            nonNegotiableConditions: (json.non_negotiable_conditions ?? []).slice(),
            status,
            publishedAt: parseDate(json.published_at),
            createdAt: parseDate(json.created_at),
            updatedAt: parseDate(json.updated_at),
        });
    }
    equals(other) {
        return JSON.stringify(this.toJSON()) === JSON.stringify(other.toJSON());
    }
}
exports.Listing = Listing;
//# sourceMappingURL=listing.entity.js.map