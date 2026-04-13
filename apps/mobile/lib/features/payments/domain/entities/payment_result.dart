class PaymentResult {
  final String transactionId;
  final PaymentStatus status;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final String? errorMessage;
  final Map<String, dynamic> providerData;

  const PaymentResult({
    required this.transactionId,
    required this.status,
    required this.amount,
    required this.currency,
    required this.timestamp,
    this.errorMessage,
    this.providerData = const {},
  });

  bool get isSuccessful => status == PaymentStatus.completed;
  bool get isPending => status == PaymentStatus.pending;
  bool get hasFailed => status == PaymentStatus.failed;
}

enum PaymentStatus { pending, completed, failed, cancelled, refunded }
