// test/client/trustless_work_config_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/models/network.dart';

void main() {
  group('TrustlessWorkConfig', () {
    test('testnet factory points to dev URL', () {
      const cfg = TrustlessWorkConfig.testnet(apiKey: 'k');
      expect(cfg.baseUrl.toString(), 'https://dev.api.trustlesswork.com');
      expect(cfg.apiKey, 'k');
      expect(cfg.network, Network.testnet);
    });

    test('mainnet factory points to prod URL', () {
      const cfg = TrustlessWorkConfig.mainnet(apiKey: 'k');
      expect(cfg.baseUrl.toString(), 'https://api.trustlesswork.com');
      expect(cfg.network, Network.mainnet);
    });

    test('custom factory accepts explicit URL', () {
      final cfg = TrustlessWorkConfig(
        baseUrl: Uri.parse('https://staging.example.com'),
        apiKey: 'k',
        network: Network.testnet,
      );
      expect(cfg.baseUrl.host, 'staging.example.com');
    });

    test('empty api key throws ArgumentError', () {
      expect(
        () => TrustlessWorkConfig(
          baseUrl: Uri.parse('https://api.trustlesswork.com'),
          apiKey: '',
          network: Network.mainnet,
        ),
        throwsArgumentError,
      );
    });
  });
}
