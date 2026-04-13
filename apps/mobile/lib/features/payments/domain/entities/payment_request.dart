class PaymentRequest {
  final String contractId;
  final double amount;
  final String currency;
  final String payerId;
  final String payeeId;
  final PaymentType type;
  final Map<String, dynamic> metadata;

  const PaymentRequest({
    required this.contractId,
    required this.amount,
    required this.currency,
    required this.payerId,
    required this.payeeId,
    required this.type,
    this.metadata = const {},
  });
}

enum PaymentType {
  // Pagos de alquiler (procesados por Kindo via SINPE)
  deposit, // Depósito de garantía
  monthlyRent, // Renta mensual
  utilities, // Servicios públicos
  fees, // Comisiones
  // Pagos de suscripción SaaS (procesados por ONVO Pay)
  saasSubscription, // Suscripción mensual del arrendador
  saasSetupFee, // Fee de configuración inicial
  saasUpgrade, // Upgrade de plan
}
