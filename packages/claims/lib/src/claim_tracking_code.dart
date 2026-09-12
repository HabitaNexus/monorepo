import 'dart:math';

/// Código de seguimiento único y legible por humano (SOP §6.3).
///
/// Formato: `RCL-XXXXXX` (6 caracteres base32 sin ambigüedades:
/// sin `0/O`, `1/I/L`). Ejemplo: `RCL-K7Q2XD`.
abstract final class ClaimTrackingCode {
  static const String prefix = 'RCL';
  static const int codeLength = 6;

  /// Alfabeto sin caracteres ambiguos.
  static const String alphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

  static final RegExp pattern =
      RegExp('^$prefix-[${RegExp.escape(alphabet)}]{$codeLength}\$');

  /// Genera un código. [random] se inyecta en tests para determinismo.
  static String generate({Random? random}) {
    final Random rng = random ?? Random.secure();
    final StringBuffer sb = StringBuffer()..write('$prefix-');
    for (int i = 0; i < codeLength; i++) {
      sb.write(alphabet[rng.nextInt(alphabet.length)]);
    }
    return sb.toString();
  }

  /// `true` si [code] cumple el formato.
  static bool isValid(String code) => pattern.hasMatch(code);
}
