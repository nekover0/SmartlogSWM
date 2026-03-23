import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keeps legacy auth fixture alias in sync with canonical fixture', () async {
    final canonicalFixture = File('assets/fixtures/auth/sample_accounts.json');
    final legacyFixture = File('asset/fixtures/auth.sample_account.json');

    expect(await canonicalFixture.exists(), isTrue);
    expect(await legacyFixture.exists(), isTrue);

    final canonicalJson = await canonicalFixture.readAsString();
    final legacyJson = await legacyFixture.readAsString();

    expect(legacyJson, canonicalJson);
  });
}
