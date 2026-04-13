import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/entities/payment/payment_request.dart';
import '../../../domain/entities/payment/payment_result.dart';
import 'payment_provider.dart';

/// Implementación específica para Kindo
/// Esta clase encapsula toda la lógica de integración con Kindo
/// El usuario final nunca sabrá que está usando Kindo
class KindoPaymentProvider implements PaymentProvider {
  static const String _baseUrl = 'https://api.kindo.cr'; // URL hipotética

  late String _apiKey;
  late String _merchantId;

  @override
  String get providerName => 'Kindo';

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    _apiKey = config['apiKey'] ?? '';
    _merchantId = config['merchantId'] ?? '';

    if (_apiKey.isEmpty || _merchantId.isEmpty) {
      throw Exception('Kindo API key and merchant ID are required');
    }
  }

  @override
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/payments'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'merchant_id': _merchantId,
          'amount': request.amount,
          'currency': request.currency,
          'reference': request.contractId,
          'payer_id': request.payerId,
          'payee_id': request.payeeId,
          'payment_type': request.type.name,
          'metadata': request.metadata,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          transactionId: data['transaction_id'],
          status: _mapKindoStatus(data['status']),
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
          errorMessage: 'Payment failed: ${response.body}',
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
    // Implementación para verificar transacción con Kindo
    // TODO: Implementar cuando tengamos acceso a la API de Kindo
    throw UnimplementedError('Pending Kindo API documentation');
  }

  @override
  Future<PaymentResult> createEscrow(PaymentRequest request) async {
    // Implementación para crear escrow con Kindo
    // TODO: Implementar cuando tengamos acceso a la API de Kindo
    throw UnimplementedError('Pending Kindo API documentation');
  }

  @override
  Future<PaymentResult> releaseEscrow(String escrowId) async {
    // Implementación para liberar escrow con Kindo
    // TODO: Implementar cuando tengamos acceso a la API de Kindo
    throw UnimplementedError('Pending Kindo API documentation');
  }

  @override
  Future<List<PaymentMethod>> getAvailablePaymentMethods() async {
    // Retorna métodos de pago disponibles en Kindo
    return [
      const PaymentMethod(
        id: 'kindo_card',
        name: 'Tarjeta de Crédito/Débito',
        type: 'card',
        supportsEscrow: true,
        maxAmount: 5000000, // 5M colones
      ),
      const PaymentMethod(
        id: 'kindo_transfer',
        name: 'Transferencia Bancaria',
        type: 'bank_transfer',
        supportsEscrow: true,
        maxAmount: 10000000, // 10M colones
      ),
    ];
  }

  @override
  bool canProcessAmount(double amount, String currency) {
    // Kindo puede manejar montos altos, superando límites de SINPE Móvil
    if (currency == 'CRC') {
      return amount <= 10000000; // 10M colones máximo
    }
    return false;
  }

  PaymentStatus _mapKindoStatus(String kindoStatus) {
    switch (kindoStatus.toLowerCase()) {
      case 'completed':
      case 'success':
        return PaymentStatus.completed;
      case 'pending':
      case 'processing':
        return PaymentStatus.pending;
      case 'failed':
      case 'error':
        return PaymentStatus.failed;
      case 'cancelled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }
}
