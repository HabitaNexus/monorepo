import 'package:freezed_annotation/freezed_annotation.dart';

part 'flags.freezed.dart';
part 'flags.g.dart';

/// Lifecycle flags tracked by the Trustless Work contract.
///
/// These gate which operations are legal at any moment — e.g. you cannot
/// `releaseFunds` if `disputed` is true, and you cannot re-fund once
/// `released` is true.
@freezed
class Flags with _$Flags {
  const factory Flags({
    @Default(false) bool approved,
    @Default(false) bool disputed,
    @Default(false) bool released,
  }) = _Flags;

  factory Flags.fromJson(Map<String, dynamic> json) => _$FlagsFromJson(json);
}
