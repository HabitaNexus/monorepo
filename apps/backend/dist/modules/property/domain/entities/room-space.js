"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RoomSpace = void 0;
const catalog_types_1 = require("./catalog-types");
class RoomSpace {
    type;
    label;
    lengthM;
    widthM;
    capacityNotes;
    constructor(props) {
        this.type = props.type;
        this.label = props.label;
        this.lengthM = props.lengthM;
        this.widthM = props.widthM;
        this.capacityNotes = props.capacityNotes;
        Object.freeze(this);
    }
    static create(props) {
        return new RoomSpace({
            capacityNotes: null,
            ...props,
        });
    }
    get areaM2() {
        return this.lengthM * this.widthM;
    }
    copy(patch) {
        return RoomSpace.create({
            type: patch.type ?? this.type,
            label: patch.label ?? this.label,
            lengthM: patch.lengthM ?? this.lengthM,
            widthM: patch.widthM ?? this.widthM,
            capacityNotes: patch.capacityNotes ?? this.capacityNotes,
        });
    }
    toJSON() {
        return {
            type: this.type,
            label: this.label,
            length_m: this.lengthM,
            width_m: this.widthM,
            area_m2: this.areaM2,
            capacity_notes: this.capacityNotes,
        };
    }
    static fromJSON(json) {
        const type = json.type;
        if (!Object.values(catalog_types_1.RoomSpaceType).includes(type)) {
            throw new Error(`Unknown RoomSpaceType: ${String(json.type)}`);
        }
        return RoomSpace.create({
            type,
            label: json.label,
            lengthM: json.length_m ?? 0,
            widthM: json.width_m ?? 0,
            capacityNotes: json.capacity_notes ?? null,
        });
    }
    equals(other) {
        return (this.type === other.type &&
            this.label === other.label &&
            this.lengthM === other.lengthM &&
            this.widthM === other.widthM &&
            this.capacityNotes === other.capacityNotes);
    }
}
exports.RoomSpace = RoomSpace;
//# sourceMappingURL=room-space.js.map