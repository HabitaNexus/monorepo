import { Listing } from '../entities/listing.entity';
import { Property } from '../entities/property.entity';
export interface PropertyRepository {
    findById(id: string): Promise<Property | null>;
    findByOwner(ownerId: string): Promise<Property[]>;
    save(property: Property): Promise<Property>;
}
export interface ListingRepository {
    findById(id: string): Promise<Listing | null>;
    findActiveByProperty(propertyId: string): Promise<Listing | null>;
    save(listing: Listing): Promise<Listing>;
}
