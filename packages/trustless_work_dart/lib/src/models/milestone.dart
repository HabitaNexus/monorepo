import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone.freezed.dart';
part 'milestone.g.dart';

/// A single deliverable inside an escrow.
///
/// v0.1 focuses on single-release contracts, which still send a
/// milestones array (typically containing one entry) to describe the
/// agreement's subject matter.
@freezed
class Milestone with _$Milestone {
  const factory Milestone({
    required String description,
    @Default('pending') String status,
    @Default(false) bool approvedFlag,
  }) = _Milestone;

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);
}
