import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/core/network/auth_interceptor.dart';
import 'package:shopsphere/core/network/session_expiry_notifier.dart';
import 'package:shopsphere/core/storage/token_storage.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

/// Answers requests from a list of canned (status, body) replies per path
/// and records every request it sees.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.replies);

  final Map<String, List<(int, Object)>> replies;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final (status, body) = replies[options.path]!.removeAt(0);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _MockTokenStorage storage;
  late SessionExpiryNotifier expiry;
  late List<void> expiredEvents;

  setUp(() {
    storage = _MockTokenStorage();
    expiry = SessionExpiryNotifier();
    expiredEvents = [];
    expiry.onExpired.listen(expiredEvents.add);
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'old');
    when(() => storage.readRefreshToken()).thenAnswer((_) async => 'refresh');
    when(
      () => storage.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
  });

  tearDown(() => expiry.dispose());

  (Dio, _FakeAdapter) build(Map<String, List<(int, Object)>> replies) {
    final adapter = _FakeAdapter(replies);
    final refreshDio = Dio()..httpClientAdapter = adapter;
    final dio = Dio()
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(
          tokenStorage: storage,
          sessionExpiry: expiry,
          refreshDio: refreshDio,
        ),
      );
    return (dio, adapter);
  }

  final authed = Options(extra: {AuthInterceptor.requiresAuth: true});

  test('attaches the Bearer token only to protected requests', () async {
    final (dio, adapter) = build({
      '/auth/me': [(200, <String, Object>{})],
      '/products': [(200, <String, Object>{})],
    });

    await dio.get<dynamic>('/auth/me', options: authed);
    await dio.get<dynamic>('/products');

    expect(adapter.requests[0].headers['Authorization'], 'Bearer old');
    expect(adapter.requests[1].headers.containsKey('Authorization'), isFalse);
  });

  test('refreshes an expired token, saves it and retries once', () async {
    final (dio, adapter) = build({
      '/auth/me': [
        (401, {'message': 'Token Expired!'}),
        (200, {'id': 1}),
      ],
      '/auth/refresh': [
        (200, {'accessToken': 'new', 'refreshToken': 'new-refresh'}),
      ],
    });

    final response = await dio.get<dynamic>('/auth/me', options: authed);

    expect(response.statusCode, 200);
    expect(adapter.requests.last.headers['Authorization'], 'Bearer new');
    verify(
      () => storage.saveTokens(accessToken: 'new', refreshToken: 'new-refresh'),
    ).called(1);
    expect(expiredEvents, isEmpty);
  });

  test('signs out when the refresh token is rejected with 403', () async {
    final (dio, _) = build({
      '/auth/me': [
        (401, {'message': 'Token Expired!'}),
      ],
      '/auth/refresh': [
        (403, {'message': 'Invalid refresh token'}),
      ],
    });

    await expectLater(
      dio.get<dynamic>('/auth/me', options: authed),
      throwsA(isA<DioException>()),
    );
    await pumpEventQueue();

    verify(() => storage.clear()).called(1);
    expect(expiredEvents, hasLength(1));
  });

  test('keeps the session when the refresh fails for a server error', () async {
    final (dio, _) = build({
      '/auth/me': [
        (401, {'message': 'Token Expired!'}),
      ],
      '/auth/refresh': [
        (500, {'message': 'boom'}),
      ],
    });

    await expectLater(
      dio.get<dynamic>('/auth/me', options: authed),
      throwsA(isA<DioException>()),
    );
    await pumpEventQueue();

    verifyNever(() => storage.clear());
    expect(expiredEvents, isEmpty);
  });
}
