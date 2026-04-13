/// Configuración centralizada para proveedores de pago
/// Permite cambiar fácilmente entre Kindo y otros proveedores
class PaymentConfig {
  static const String defaultProvider = 'kindo';

  static const Map<String, Map<String, dynamic>> providers = {
    'kindo': {
      'apiKey': String.fromEnvironment('KINDO_API_KEY'),
      'merchantId': String.fromEnvironment('KINDO_MERCHANT_ID'),
      'baseUrl': 'https://api.kindo.cr',
      'maxAmount': 10000000, // 10M colones
      'supportedCurrencies': ['CRC'],
      'supportsEscrow': true,
      'paymentTypes': ['deposit', 'monthlyRent', 'utilities', 'fees'],
      'description': 'Pagos de alquiler via SINPE interbancaria',
    },
    'onvo': {
      'apiKey': String.fromEnvironment('ONVO_API_KEY'),
      'merchantId': String.fromEnvironment('ONVO_MERCHANT_ID'),
      'baseUrl': 'https://api.onvopay.com',
      'maxAmount': 1000000, // 1M colones para suscripciones
      'supportedCurrencies': ['CRC'],
      'supportsEscrow': false,
      'paymentTypes': ['saasSubscription', 'saasSetupFee', 'saasUpgrade'],
      'description': 'Suscripciones SaaS para arrendadores',
    },
    'stripe': {
      'apiKey': String.fromEnvironment('STRIPE_API_KEY'),
      'publishableKey': String.fromEnvironment('STRIPE_PUBLISHABLE_KEY'),
      'baseUrl': 'https://api.stripe.com',
      'maxAmount': 999999999,
      'supportedCurrencies': ['USD', 'CRC'],
      'supportsEscrow': false,
      'paymentTypes': ['backup'], // Respaldo si otros fallan
      'description': 'Proveedor de respaldo internacional',
    },
  };

  static Map<String, dynamic> getProviderConfig(String providerName) {
    return providers[providerName] ?? providers[defaultProvider]!;
  }

  static bool isProviderAvailable(String providerName) {
    final config = providers[providerName];
    if (config == null) return false;

    // Verifica que tenga las credenciales necesarias
    return config['apiKey'] != null && config['apiKey'].toString().isNotEmpty;
  }
}
