import '../../../domain/entities/payment/payment_request.dart';
import '../../../domain/entities/payment/payment_result.dart';

/// Abstracción para proveedores de pago
/// Permite integrar Kindo, Stripe, PayPal, etc. sin cambiar la lógica de negocio
abstract class PaymentProvider {
  String get providerName;

  /// Inicializa el proveedor con configuración específica
  Future<void> initialize(Map<String, dynamic> config);

  /// Procesa un pago
  Future<PaymentResult> processPayment(PaymentRequest request);

  /// Verifica una transacción
  Future<PaymentResult> verifyTransaction(String transactionId);

  /// Crea un escrow
  Future<PaymentResult> createEscrow(PaymentRequest request);

  /// Libera fondos del escrow
  Future<PaymentResult> releaseEscrow(String escrowId);

  /// Obtiene métodos de pago disponibles
  Future<List<PaymentMethod>> getAvailablePaymentMethods();

  /// Valida si puede procesar el monto solicitado
  bool canProcessAmount(double amount, String currency);
}

class PaymentMethod {
  final String id;
  final String name;
  final String
  type; // 'card', 'bank_transfer', 'digital_wallet', 'subscription'
  final bool supportsEscrow;
  final double? maxAmount;
  final double? minAmount;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    required this.supportsEscrow,
    this.maxAmount,
    this.minAmount,
  });
}
