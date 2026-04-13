import '../entities/payment/payment_request.dart';
import '../entities/payment/payment_result.dart';

abstract class PaymentRepository {
  /// Procesa un pago usando el proveedor configurado
  Future<PaymentResult> processPayment(PaymentRequest request);

  /// Verifica el estado de una transacción
  Future<PaymentResult> verifyTransaction(String transactionId);

  /// Crea un escrow para proteger fondos
  Future<PaymentResult> createEscrow(PaymentRequest request);

  /// Libera fondos del escrow
  Future<PaymentResult> releaseEscrow(String escrowId);

  /// Obtiene el historial de pagos de un contrato
  Future<List<PaymentResult>> getPaymentHistory(String contractId);

  /// Configura método de pago del usuario
  Future<bool> setupPaymentMethod(
    String userId,
    Map<String, dynamic> paymentData,
  );
}
