import '../../domain/entities/payment/payment_request.dart';
import '../../domain/entities/payment/payment_result.dart';
import '../datasources/payment/payment_provider.dart';
import '../datasources/payment/kindo_payment_provider.dart';
import '../datasources/payment/onvo_payment_provider.dart';
import '../config/payment_config.dart';

/// Router inteligente que decide qué proveedor usar según el tipo de pago
/// - Kindo: Para pagos de alquiler (inquilino → propietario) via SINPE
/// - ONVO Pay: Para suscripciones SaaS (arrendador → plataforma)
class PaymentRouter {
  final Map<String, PaymentProvider> _providers = {};

  PaymentRouter() {
    _initializeProviders();
  }

  Future<void> _initializeProviders() async {
    // Inicializar Kindo para pagos de alquiler
    if (PaymentConfig.isProviderAvailable('kindo')) {
      final kindoProvider = KindoPaymentProvider();
      await kindoProvider.initialize(PaymentConfig.getProviderConfig('kindo'));
      _providers['kindo'] = kindoProvider;
    }

    // Inicializar ONVO Pay para suscripciones SaaS
    if (PaymentConfig.isProviderAvailable('onvo')) {
      final onvoProvider = OnvoPaymentProvider();
      await onvoProvider.initialize(PaymentConfig.getProviderConfig('onvo'));
      _providers['onvo'] = onvoProvider;
    }
  }

  /// Selecciona automáticamente el proveedor correcto según el tipo de pago
  PaymentProvider? getProviderForPayment(PaymentType paymentType) {
    switch (paymentType) {
      // Pagos de alquiler → Kindo (SINPE interbancaria)
      case PaymentType.deposit:
      case PaymentType.monthlyRent:
      case PaymentType.utilities:
      case PaymentType.fees:
        return _providers['kindo'];

      // Suscripciones SaaS → ONVO Pay
      case PaymentType.saasSubscription:
      case PaymentType.saasSetupFee:
      case PaymentType.saasUpgrade:
        return _providers['onvo'];
    }
  }

  /// Procesa un pago usando el proveedor apropiado
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    final provider = getProviderForPayment(request.type);

    if (provider == null) {
      return PaymentResult(
        transactionId: '',
        status: PaymentStatus.failed,
        amount: request.amount,
        currency: request.currency,
        timestamp: DateTime.now(),
        errorMessage: 'No payment provider available for ${request.type}',
      );
    }

    return await provider.processPayment(request);
  }

  /// Verifica una transacción en el proveedor correcto
  Future<PaymentResult> verifyTransaction(
    String transactionId,
    PaymentType paymentType,
  ) async {
    final provider = getProviderForPayment(paymentType);

    if (provider == null) {
      throw Exception('No provider found for payment type: $paymentType');
    }

    return await provider.verifyTransaction(transactionId);
  }

  /// Obtiene métodos de pago disponibles para un tipo específico
  Future<List<PaymentMethod>> getAvailablePaymentMethods(
    PaymentType paymentType,
  ) async {
    final provider = getProviderForPayment(paymentType);

    if (provider == null) {
      return [];
    }

    return await provider.getAvailablePaymentMethods();
  }

  /// Información sobre qué proveedor se usará para cada tipo de pago
  Map<String, String> getPaymentProviderInfo() {
    return {
      'Pagos de alquiler (depósitos, rentas)':
          _providers['kindo']?.providerName ?? 'No disponible',
      'Suscripciones SaaS (arrendadores)':
          _providers['onvo']?.providerName ?? 'No disponible',
      'Red de pagos de alquiler': 'SINPE Interbancaria (Costa Rica)',
      'Límite SINPE superado': 'Sí, via integración bancaria directa',
    };
  }
}
