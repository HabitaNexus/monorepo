// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_escrows_from_indexer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetEscrowsFromIndexerResponseImpl
    _$$GetEscrowsFromIndexerResponseImplFromJson(Map<String, dynamic> json) =>
        _$GetEscrowsFromIndexerResponseImpl(
          escrows: (json['escrows'] as List<dynamic>)
              .map((e) => IndexerEscrow.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$$GetEscrowsFromIndexerResponseImplToJson(
        _$GetEscrowsFromIndexerResponseImpl instance) =>
    <String, dynamic>{
      'escrows': instance.escrows.map((e) => e.toJson()).toList(),
    };

_$IndexerEscrowImpl _$$IndexerEscrowImplFromJson(Map<String, dynamic> json) =>
    _$IndexerEscrowImpl(
      contractId: json['contractId'] as String,
      engagementId: json['engagementId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      platformFee: (json['platformFee'] as num).toDouble(),
      receiverMemo: (json['receiverMemo'] as num).toInt(),
      roles: IndexerEscrowRoles.fromJson(json['roles'] as Map<String, dynamic>),
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => IndexerMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      trustline:
          IndexerTrustline.fromJson(json['trustline'] as Map<String, dynamic>),
      flags: IndexerEscrowFlags.fromJson(json['flags'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool,
      signer: json['signer'] as String?,
      type: json['type'] as String?,
      balance: json['balance'] as num?,
      createdAt: json['createdAt'] == null
          ? null
          : IndexerTimestamp.fromJson(
              json['createdAt'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? null
          : IndexerTimestamp.fromJson(
              json['updatedAt'] as Map<String, dynamic>),
      fundedBy: json['fundedBy'] as String?,
      approverFunds: json['approverFunds'] as num?,
      receiverFunds: json['receiverFunds'] as num?,
      user: json['user'] as String?,
      disputeStartedBy: json['disputeStartedBy'] as String?,
    );

Map<String, dynamic> _$$IndexerEscrowImplToJson(_$IndexerEscrowImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'engagementId': instance.engagementId,
      'title': instance.title,
      'description': instance.description,
      'platformFee': instance.platformFee,
      'receiverMemo': instance.receiverMemo,
      'roles': instance.roles.toJson(),
      'milestones': instance.milestones.map((e) => e.toJson()).toList(),
      'trustline': instance.trustline.toJson(),
      'flags': instance.flags.toJson(),
      'isActive': instance.isActive,
      'signer': instance.signer,
      'type': instance.type,
      'balance': instance.balance,
      'createdAt': instance.createdAt?.toJson(),
      'updatedAt': instance.updatedAt?.toJson(),
      'fundedBy': instance.fundedBy,
      'approverFunds': instance.approverFunds,
      'receiverFunds': instance.receiverFunds,
      'user': instance.user,
      'disputeStartedBy': instance.disputeStartedBy,
    };

_$IndexerEscrowRolesImpl _$$IndexerEscrowRolesImplFromJson(
        Map<String, dynamic> json) =>
    _$IndexerEscrowRolesImpl(
      approver: json['approver'] as String?,
      serviceProvider: json['serviceProvider'] as String?,
      platformAddress: json['platformAddress'] as String?,
      releaseSigner: json['releaseSigner'] as String?,
      disputeResolver: json['disputeResolver'] as String?,
      receiver: json['receiver'] as String?,
      issuer: json['issuer'] as String?,
    );

Map<String, dynamic> _$$IndexerEscrowRolesImplToJson(
        _$IndexerEscrowRolesImpl instance) =>
    <String, dynamic>{
      'approver': instance.approver,
      'serviceProvider': instance.serviceProvider,
      'platformAddress': instance.platformAddress,
      'releaseSigner': instance.releaseSigner,
      'disputeResolver': instance.disputeResolver,
      'receiver': instance.receiver,
      'issuer': instance.issuer,
    };

_$IndexerMilestoneImpl _$$IndexerMilestoneImplFromJson(
        Map<String, dynamic> json) =>
    _$IndexerMilestoneImpl(
      description: json['description'] as String,
      status: json['status'] as String? ?? 'pending',
      flags:
          IndexerMilestoneFlags.fromJson(json['flags'] as Map<String, dynamic>),
      amount: json['amount'] as num?,
      evidence: json['evidence'] as String?,
      receiver: json['receiver'] as String?,
    );

Map<String, dynamic> _$$IndexerMilestoneImplToJson(
        _$IndexerMilestoneImpl instance) =>
    <String, dynamic>{
      'description': instance.description,
      'status': instance.status,
      'flags': instance.flags.toJson(),
      'amount': instance.amount,
      'evidence': instance.evidence,
      'receiver': instance.receiver,
    };

_$IndexerMilestoneFlagsImpl _$$IndexerMilestoneFlagsImplFromJson(
        Map<String, dynamic> json) =>
    _$IndexerMilestoneFlagsImpl(
      approved: json['approved'] as bool? ?? false,
      disputed: json['disputed'] as bool? ?? false,
      released: json['released'] as bool? ?? false,
      resolved: json['resolved'] as bool? ?? false,
    );

Map<String, dynamic> _$$IndexerMilestoneFlagsImplToJson(
        _$IndexerMilestoneFlagsImpl instance) =>
    <String, dynamic>{
      'approved': instance.approved,
      'disputed': instance.disputed,
      'released': instance.released,
      'resolved': instance.resolved,
    };

_$IndexerEscrowFlagsImpl _$$IndexerEscrowFlagsImplFromJson(
        Map<String, dynamic> json) =>
    _$IndexerEscrowFlagsImpl(
      disputed: json['disputed'] as bool? ?? false,
      released: json['released'] as bool? ?? false,
      resolved: json['resolved'] as bool? ?? false,
    );

Map<String, dynamic> _$$IndexerEscrowFlagsImplToJson(
        _$IndexerEscrowFlagsImpl instance) =>
    <String, dynamic>{
      'disputed': instance.disputed,
      'released': instance.released,
      'resolved': instance.resolved,
    };

_$IndexerTrustlineImpl _$$IndexerTrustlineImplFromJson(
        Map<String, dynamic> json) =>
    _$IndexerTrustlineImpl(
      address: json['address'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$IndexerTrustlineImplToJson(
        _$IndexerTrustlineImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'name': instance.name,
    };

_$IndexerTimestampImpl _$$IndexerTimestampImplFromJson(
        Map<String, dynamic> json) =>
    _$IndexerTimestampImpl(
      seconds: (json['_seconds'] as num).toInt(),
      nanoseconds: (json['_nanoseconds'] as num).toInt(),
    );

Map<String, dynamic> _$$IndexerTimestampImplToJson(
        _$IndexerTimestampImpl instance) =>
    <String, dynamic>{
      '_seconds': instance.seconds,
      '_nanoseconds': instance.nanoseconds,
    };
