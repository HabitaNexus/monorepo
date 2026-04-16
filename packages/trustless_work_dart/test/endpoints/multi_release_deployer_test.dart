import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/endpoints/multi_release_deployer.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';
import 'package:trustless_work_dart/src/models/payloads/multi_release_contract.dart';

void main() {
  test(
    'deployMultiRelease POSTs to /deployer/multi-release and returns XDR',
    () async {
      Map<String, dynamic>? body;
      final mock = MockClient((req) async {
        expect(req.method, 'POST');
        expect(req.url.path, '/deployer/multi-release');
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({'transactionXdr': 'XDR_MULTI'}),
          201,
        );
      });

      final http_ = HttpClient(
        config: TrustlessWorkConfig.testnet(apiKey: 'k'),
        inner: mock,
      );
      final deployer = MultiReleaseDeployer(http: http_);

      final xdr = await deployer.deploy(
        const MultiReleaseContract(
          signer: 'GAAA',
          engagementId: 'lease-42',
          title: 'Alquiler + pagos',
          description: 'Depósito + 6 pagos',
          platformFee: 2.5,
          roles: <Map<String, Object?>>[],
          milestones: <Map<String, Object?>>[
            {'description': 'Depósito', 'amount': 250000},
            {'description': 'Pago mes 1', 'amount': 500000},
          ],
          trustline: <Map<String, Object?>>[],
        ),
      );

      expect(xdr, 'XDR_MULTI');
      expect(body!['signer'], 'GAAA');
      expect(body!.containsKey('amount'), isFalse);
      expect(body!['milestones'], hasLength(2));
    },
  );

  test(
    'deployMultiRelease throws ServerError when response missing transactionXdr',
    () async {
      final mock = MockClient((_) async {
        return http.Response(jsonEncode({'status': 'SUCCESS'}), 201);
      });
      final deployer = MultiReleaseDeployer(
        http: HttpClient(
          config: TrustlessWorkConfig.testnet(apiKey: 'k'),
          inner: mock,
        ),
      );
      expect(
        () => deployer.deploy(
          const MultiReleaseContract(
            signer: 'GAAA',
            engagementId: 'x',
            title: 'x',
            description: 'x',
            platformFee: 0,
            roles: <Map<String, Object?>>[],
            milestones: <Map<String, Object?>>[],
            trustline: <Map<String, Object?>>[],
          ),
        ),
        throwsA(isA<Exception>()),
      );
    },
  );
}
