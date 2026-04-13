import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/entities/payment/payment_request.dart';
import '../../../domain/entities/payment/payment_result.dart';
import 'payment_provider.dart';

/// Implementación específica para ONVO Pay
/// Maneja suscripciones SaaS de arrendadores y propietarios
class OnvoPaymentProvider implements PaymentProvider {
  static const String _baseUrl = 'https://api.onvopay.com'; // URL hipotética

  late String _apiKey;
  late String _merchantId;

  @override
  String get providerName => 'ONVO Pay';

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    _apiKey = config['apiKey'] ?? '';
    _merchantId = config['merchantId'] ?? '';

    if (_apiKey.isEmpty || _merchantId.isEmpty) {
      throw Exception('ONVO Pay API key and merchant ID are required');
    }
  }

  @override
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    // Solo procesa pagos de suscripción SaaS
    if (!_isSaasPayment(request.type)) {
      return PaymentResult(
        transactionId: '',
        status: PaymentStatus.failed,
        amount: request.amount,
        currency: request.currency,
        timestamp: DateTime.now(),
        errorMessage: 'ONVO Pay only processes SaaS subscription payments',
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/subscriptions/charge'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'merchant_id': _merchantId,
          'amount': request.amount,
          'currency': request.currency,
          'subscription_type': _mapPaymentTypeToSubscription(request.type),
          'customer_id': request.payerId,
          'reference': request.contractId,
          'metadata': request.metadata,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          transactionId: data['transaction_id'],
          status: _mapOnvoStatus(data['status']),
          amount: request.amount,
          currency: request.currency,
          timestamp: DateTime.now(),
          providerData: data,
        );
      } else {
        return PaymentResult(
          transactionId: '',
          status: PaymentStatus.failed,
          amount: request.amount,
          currency: request.currency,
          timestamp: DateTime.now(),
          errorMessage: 'ONVO Pay error: ${response.body}',
        );
      }
    } catch (e) {
      return PaymentResult(
        transactionId: '',
        status: PaymentStatus.failed,
        amount: request.amount,
        currency: request.currency,
        timestamp: DateTime.now(),
        errorMessage: 'Network error: $e',
      );
    }
  }

  @override
  Future<PaymentResult> verifyTransaction(String transactionId) async {
    // TODO: Implementar cuando tengamos acceso a la API de ONVO Pay
    throw UnimplementedError('Pending ONVO Pay API documentation');
  }

  @override
  Future<PaymentResult> createEscrow(PaymentRequest request) async {
    // ONVO Pay no maneja escrow, solo suscripciones
    return PaymentResult(
      transactionId: '',
      status: PaymentStatus.failed,
      amount: request.amount,
      currency: request.currency,
      timestamp: DateTime.now(),
      errorMessage: 'ONVO Pay does not support escrow functionality',
    );
  }

  @override
  Future<PaymentResult> releaseEscrow(String escrowId) async {
    // ONVO Pay no maneja escrow
    throw UnsupportedError('ONVO Pay does not support escrow functionality');
  }

  @override
  Future<List<PaymentMethod>> getAvailablePaymentMethods() async {
    return [
      const PaymentMethod(
        id: 'onvo_card',
        name: 'Tarjeta de Crédito/Débito',
        type: 'card',
        supportsEscrow: false,
        maxAmount: 1000000, // 1M colones para suscripciones
      ),
      const PaymentMethod(
        id: 'onvo_recurring',
        name: 'Pago Recurrente',
        type: 'subscription',
        supportsEscrow: false,
        maxAmount: 500000, // 500K colones mensuales
      ),
    ];
  }

  @override
  bool canProcessAmount(double amount, String currency) {
    // ONVO Pay para suscripciones, montos más bajos
    if (currency == 'CRC') {
      return amount <= 1000000; // 1M colones máximo para suscripciones
    }
    return false;
  }

  bool _isSaasPayment(PaymentType type) {
    return [
      PaymentType.saasSubscription,
      PaymentType.saasSetupFee,
      PaymentType.saasUpgrade,
    ].contains(type);
  }

  String _mapPaymentTypeToSubscription(PaymentType type) {
    switch (type) {
      case PaymentType.saasSubscription:
        return 'monthly_subscription';
      case PaymentType.saasSetupFee:
        return 'setup_fee';
      case PaymentType.saasUpgrade:
        return 'plan_upgrade';
      default:
        return 'subscription';
    }
  }

  PaymentStatus _mapOnvoStatus(String onvoStatus) {
    switch (onvoStatus.toLowerCase()) {
      case 'completed':
      case 'success':
      case 'active':
        return PaymentStatus.completed;
      case 'pending':
      case 'processing':
        return PaymentStatus.pending;
      case 'failed':
      case 'error':
      case 'declined':
        return PaymentStatus.failed;
      case 'cancelled':
      case 'inactive':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }
}
