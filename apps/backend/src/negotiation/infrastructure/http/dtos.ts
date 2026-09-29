import { Type } from 'class-transformer';
import {
  IsIn,
  IsNotEmpty,
  IsObject,
  IsOptional,
  IsString,
  IsUUID,
  ValidateNested,
} from 'class-validator';

export class TermsDocumentDto {
  @IsIn([1])
  version!: 1;

  @IsObject()
  terms!: Record<string, unknown>;
}

export class ProposeDto {
  @IsUUID()
  listingId!: string;

  @IsString()
  @IsNotEmpty()
  tenantId!: string;

  @IsString()
  @IsNotEmpty()
  ownerId!: string;

  @ValidateNested()
  @Type(() => TermsDocumentDto)
  terms!: TermsDocumentDto;

  @IsString()
  @IsNotEmpty()
  actor!: string;

  @IsOptional()
  @IsUUID()
  attemptId?: string;
}

export class CounterProposeDto {
  @ValidateNested()
  @Type(() => TermsDocumentDto)
  terms!: TermsDocumentDto;

  @IsString()
  @IsNotEmpty()
  actor!: string;

  @IsOptional()
  @IsUUID()
  attemptId?: string;
}

export class AcceptDto {
  @IsString()
  @IsNotEmpty()
  actor!: string;

  @IsOptional()
  @IsUUID()
  attemptId?: string;
}

export class RejectDto {
  @IsString()
  @IsNotEmpty()
  reason!: string;

  @IsString()
  @IsNotEmpty()
  actor!: string;

  @IsOptional()
  @IsUUID()
  attemptId?: string;
}

export class ConfirmSummaryDto {
  @IsIn(['TENANT', 'OWNER'])
  party!: 'TENANT' | 'OWNER';

  @IsString()
  @IsNotEmpty()
  actor!: string;

  @IsOptional()
  @IsUUID()
  attemptId?: string;
}
