import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/endpoints/deployer.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';
import 'package:trustless_work_dart/src/models/payloads/single_release_contract.dart';

void main() {
  test('deploySingleRelease POSTs to /deployer/single-release and returns XDR', () async {
    Map<String, dynamic>? body;
    final mock = MockClient((req) async {
      expect(req.url.path, '/deployer/single-release');
      body = jsonDecode(req.body) as Map<String, dynamic>;
      return http.Response(jsonEncode({'transactionXdr': 'XDR_HERE'}), 201);
    });

    final http_ = HttpClient(
      config: TrustlessWorkConfig.testnet(apiKey: 'k'),
      inner: mock,
    );
    final deployer = SingleReleaseDeployer(http: http_);

    final xdr = await deployer.deploy(
      const SingleReleaseContract(
        signer: 'GAAA',
        engagementId: 'lease-1',
        title: 'x',
        description: 'y',
        amount: 1,
        platformFee: 0,
        roles: [],
        milestones: [],
        trustline: [],
      ),
    );

    expect(xdr, 'XDR_HERE');
    expect(body!['signer'], 'GAAA');
  });
}
