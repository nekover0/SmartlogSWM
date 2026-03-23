import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException([
    this.message = 'Invalid username or password.',
  ]);

  final String message;

  @override
  String toString() => message;
}

class AuthFixtureDataSource {
  AuthFixtureDataSource({
    AssetBundle? assetBundle,
    this.fixturePath = _defaultFixturePath,
  }) : _assetBundle = assetBundle ?? rootBundle;

  static const String _defaultFixturePath =
      'assets/fixtures/auth/sample_accounts.json';

  final AssetBundle _assetBundle;
  final String fixturePath;

  List<AuthSampleAccount>? _cachedAccounts;

  Future<List<AuthSampleAccount>> getSampleAccounts() async {
    if (_cachedAccounts != null) {
      return _cachedAccounts!;
    }

    final rawJson = await _assetBundle.loadString(fixturePath);
    final payload = jsonDecode(rawJson) as Map<String, dynamic>;
    final accountsJson = payload['accounts'] as List<dynamic>;

    _cachedAccounts = accountsJson
        .map(
          (entry) => AuthSampleAccount.fromJson(entry as Map<String, dynamic>),
        )
        .toList(growable: false);

    return _cachedAccounts!;
  }

  Future<LoginResponseDto> login(LoginRequestDto request) async {
    final normalizedUsername = request.username.trim().toLowerCase();
    final password = request.password.trim();
    final accounts = await getSampleAccounts();

    final matchedAccount = accounts.cast<AuthSampleAccount?>().firstWhere(
      (account) =>
          account != null &&
          account.username.trim().toLowerCase() == normalizedUsername &&
          account.password == password,
      orElse: () => null,
    );

    if (matchedAccount == null) {
      throw const InvalidCredentialsException();
    }

    return LoginResponseDto(
      accessToken: 'fixture-token-${matchedAccount.id}',
      user: matchedAccount.toAuthUser(),
    );
  }
}
