import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/errors/trustless_work_error.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';

void main() {
  group('HttpClient', () {
    final cfg = TrustlessWorkConfig.testnet(apiKey: 'test_key');

    test('sends api key header and returns decoded JSON on 200', () async {
      final mock = MockClient((req) async {
        expect(req.headers['x-api-key'], 'test_key');
        expect(req.headers['content-type'], contains('application/json'));
        return http.Response(jsonEncode({'contractId': 'abc'}), 200);
      });

      final client = HttpClient(config: cfg, inner: mock);
      final result = await client.postJson<Map<String, dynamic>>(
        '/deployer/single-release',
        body: const {'foo': 'bar'},
      );
      expect(result['contractId'], 'abc');
    });

    test('maps 400 to BadRequest', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({'message': 'missing amount'}),
            400,
          ));

      final client = HttpClient(config: cfg, inner: mock);
      await expectLater(
        client.postJson<Map<String, dynamic>>('/x', body: const {}),
        throwsA(isA<BadRequest>()),
      );
    });

    test('maps 401 to Unauthorized', () async {
      final mock = MockClient((_) async => http.Response('', 401));
      final client = HttpClient(config: cfg, inner: mock);
      await expectLater(
        client.postJson<Map<String, dynamic>>('/x', body: const {}),
        throwsA(isA<Unauthorized>()),
      );
    });

    test('maps 429 to TooManyRequests', () async {
      final mock = MockClient((_) async => http.Response('', 429));
      final client = HttpClient(config: cfg, inner: mock);
      await expectLater(
        client.postJson<Map<String, dynamic>>('/x', body: const {}),
        throwsA(isA<TooManyRequests>()),
      );
    });

    test('maps 500 with message to ServerError', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({'message': 'Escrow not found'}),
            500,
          ));
      final client = HttpClient(config: cfg, inner: mock);
      await expectLater(
        client.postJson<Map<String, dynamic>>('/x', body: const {}),
        throwsA(isA<ServerError>()),
      );
    });

    test('wraps socket-level failures as NetworkError', () async {
      final mock = MockClient((_) async => throw http.ClientException('boom'));
      final client = HttpClient(config: cfg, inner: mock);
      await expectLater(
        client.postJson<Map<String, dynamic>>('/x', body: const {}),
        throwsA(isA<NetworkError>()),
      );
    });
  });
}
