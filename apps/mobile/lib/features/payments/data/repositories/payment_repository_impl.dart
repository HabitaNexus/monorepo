import '../../domain/entities/payment/payment_request.dart';
import '../../domain/entities/payment/payment_result.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../core/services/payment_router.dart';

/// Implementación del repositorio de pagos
/// Utiliza PaymentRouter para seleccionar automáticamente el proveedor correcto
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRouter _paymentRouter;
  final Map<String, PaymentResult> _transactionCache = {};

  PaymentRepositoryImpl(this._paymentRouter);

  @override
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    // El router selecciona automáticamente el proveedor correcto
    final result = await _paymentRouter.processPayment(request);

    // Cache del resultado para consultas rápidas
    if (result.transactionId.isNotEmpty) {
      _transactionCache[result.transactionId] = result;
    }

    return result;
  }

  @override
  Future<PaymentResult> verifyTransaction(String transactionId) async {
    // Primero busca en cache
    if (_transactionCache.containsKey(transactionId)) {
      final cachedResult = _transactionCache[transactionId]!;
      // Si está completado o falló, retorna el cache
      if (cachedResult.status == PaymentStatus.completed ||
          cachedResult.status == PaymentStatus.failed) {
        return cachedResult;
      }
    }

    // Necesitamos el tipo de pago para saber qué proveedor usar
    // Por ahora, intentamos con ambos proveedores
    // TODO: Mejorar esto guardando el tipo de pago en el cache
    throw UnimplementedError('Need payment type to verify transaction');
  }

  @override
  Future<PaymentResult> createEscrow(PaymentRequest request) async {
    // Solo Kindo soporta escrow, ONVO Pay no
    final provider = _paymentRouter.getProviderForPayment(request.type);
    if (provider == null) {
      return PaymentResult(
        transactionId: '',
        status: PaymentStatus.failed,
        amount: request.amount,
        currency: request.currency,
        timestamp: DateTime.now(),
        errorMessage: 'No provider available for escrow',
      );
    }
    return await provider.createEscrow(request);
  }

  @override
  Future<PaymentResult> releaseEscrow(String escrowId) async {
    // Solo Kindo maneja escrow
    final kindoProvider = _paymentRouter.getProviderForPayment(
      PaymentType.deposit,
    );
    if (kindoProvider == null) {
      throw Exception('Kindo provider not available for escrow release');
    }
    return await kindoProvider.releaseEscrow(escrowId);
  }

  @override
  Future<List<PaymentResult>> getPaymentHistory(String contractId) async {
    // Filtra transacciones por contractId
    return _transactionCache.values
        .where((result) => result.providerData['reference'] == contractId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<bool> setupPaymentMethod(
    String userId,
    Map<String, dynamic> paymentData,
  ) async {
    // Implementación para configurar método de pago
    // Esto dependerá de la API específica del proveedor
    try {
      // TODO: Implementar configuración de método de pago
      return true;
    } catch (e) {
      return false;
    }
  }
}
