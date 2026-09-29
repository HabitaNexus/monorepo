import '../domain/entities/payment_request.dart';
import '../domain/entities/payment_result.dart';
import '../data/repositories/payment_repository_impl.dart';
import '../domain/usecases/payment_router.dart';

/// Ejemplo de uso del sistema de pagos dual
/// Muestra cómo se procesan diferentes tipos de pagos automáticamente
class PaymentUsageExample {
  late PaymentRepositoryImpl _paymentRepository;

  PaymentUsageExample() {
    final paymentRouter = PaymentRouter();
    _paymentRepository = PaymentRepositoryImpl(paymentRouter);
  }

  /// Ejemplo: Inquilino paga depósito de garantía
  /// Se procesa automáticamente via Kindo + SINPE
  Future<void> processSecurityDeposit() async {
    final depositRequest = PaymentRequest(
      contractId: 'contract_123',
      amount: 450000, // ¢450,000 (supera límite SINPE Móvil)
      currency: 'CRC',
      payerId: 'tenant_456',
      payeeId: 'owner_789',
      type: PaymentType.deposit, // → Automáticamente usa Kindo
      metadata: {
        'property_id': 'prop_001',
        'deposit_type': 'security',
        'months_covered': 1,
      },
    );

    final result = await _paymentRepository.processPayment(depositRequest);

    if (result.isSuccessful) {
      print('✅ Depósito procesado via SINPE: ${result.transactionId}');
      print('💰 Monto: ¢${result.amount.toStringAsFixed(0)}');
      print('🏦 Red: SINPE Interbancaria');
    } else {
      print('❌ Error en depósito: ${result.errorMessage}');
    }
  }

  /// Ejemplo: Arrendador paga suscripción mensual SaaS
  /// Se procesa automáticamente via ONVO Pay
  Future<void> processManagerSubscription() async {
    final subscriptionRequest = PaymentRequest(
      contractId: 'subscription_456',
      amount: 25000, // ¢25,000 mensual
      currency: 'CRC',
      payerId: 'manager_123',
      payeeId: 'platform_saas',
      type: PaymentType.saasSubscription, // → Automáticamente usa ONVO Pay
      metadata: {
        'plan': 'professional',
        'properties_limit': 50,
        'billing_cycle': 'monthly',
      },
    );

    final result = await _paymentRepository.processPayment(subscriptionRequest);

    if (result.isSuccessful) {
      print('✅ Suscripción procesada: ${result.transactionId}');
      print('💳 Plan: Profesional');
      print('📅 Próximo cobro: ${_getNextBillingDate()}');
    } else {
      print('❌ Error en suscripción: ${result.errorMessage}');
    }
  }

  /// Ejemplo: Pago mensual de renta con escrow
  /// Fondos retenidos hasta confirmación de ambas partes
  Future<void> processMonthlyRentWithEscrow() async {
    final rentRequest = PaymentRequest(
      contractId: 'contract_123',
      amount: 350000, // ¢350,000 mensual
      currency: 'CRC',
      payerId: 'tenant_456',
      payeeId: 'owner_789',
      type: PaymentType.monthlyRent, // → Kindo con escrow
      metadata: {
        'month': '2025-02',
        'property_address': 'San José, Costa Rica',
        'use_escrow': true,
      },
    );

    // Crear escrow primero
    final escrowResult = await _paymentRepository.createEscrow(rentRequest);

    if (escrowResult.isSuccessful) {
      print('🔒 Escrow creado: ${escrowResult.transactionId}');
      print('⏳ Fondos retenidos hasta confirmación');

      // Simular confirmación después de algunos días
      await Future.delayed(Duration(seconds: 2));

      // Liberar fondos del escrow
      final releaseResult = await _paymentRepository.releaseEscrow(
        escrowResult.transactionId,
      );

      if (releaseResult.isSuccessful) {
        print('✅ Fondos liberados al propietario');
        print('📧 Notificaciones enviadas a ambas partes');
      }
    }
  }

  /// Ejemplo: Obtener historial de pagos de un contrato
  Future<void> getPaymentHistory() async {
    final history = await _paymentRepository.getPaymentHistory('contract_123');

    print('\n📊 Historial de Pagos - Contrato 123:');
    for (final payment in history) {
      final provider = _getProviderName(payment);
      print(
        '${payment.timestamp.toString().substring(0, 10)} | '
        '¢${payment.amount.toStringAsFixed(0)} | '
        '$provider | ${payment.status.name}',
      );
    }
  }

  String _getProviderName(PaymentResult payment) {
    // Determina qué proveedor se usó basándose en los datos
    if (payment.providerData.containsKey('sinpe_reference')) {
      return 'Kindo (SINPE)';
    } else if (payment.providerData.containsKey('subscription_id')) {
      return 'ONVO Pay';
    }
    return 'Desconocido';
  }

  String _getNextBillingDate() {
    final nextMonth = DateTime.now().add(Duration(days: 30));
    return '${nextMonth.day}/${nextMonth.month}/${nextMonth.year}';
  }
}

/// Función principal para ejecutar ejemplos
void main() async {
  final example = PaymentUsageExample();

  print('🏠 Sistema de Pagos Dual - Marketplace de Alquiler\n');

  // Ejemplo 1: Depósito de garantía via Kindo/SINPE
  print('1️⃣ Procesando depósito de garantía...');
  await example.processSecurityDeposit();

  print('\n2️⃣ Procesando suscripción SaaS...');
  await example.processManagerSubscription();

  print('\n3️⃣ Procesando renta mensual con escrow...');
  await example.processMonthlyRentWithEscrow();

  print('\n4️⃣ Consultando historial...');
  await example.getPaymentHistory();

  print('\n✨ Ejemplos completados');
}
