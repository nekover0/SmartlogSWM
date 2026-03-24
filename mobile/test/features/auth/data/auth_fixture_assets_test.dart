import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('keeps legacy auth fixture aliases in sync with canonical fixture', () async {
    final canonicalFixture = File('assets/fixtures/auth/sample_accounts.json');
    final legacyFlatFixture = File('asset/fixtures/auth.sample_account.json');
    final legacyNestedFixture = File('asset/fixtures/auth/sample_accounts.json');

    expect(await canonicalFixture.exists(), isTrue);
    expect(await legacyFlatFixture.exists(), isTrue);
    expect(await legacyNestedFixture.exists(), isTrue);

    final canonicalJson = await canonicalFixture.readAsString();
    final legacyFlatJson = await legacyFlatFixture.readAsString();
    final legacyNestedJson = await legacyNestedFixture.readAsString();

    expect(legacyFlatJson, canonicalJson);
    expect(legacyNestedJson, canonicalJson);
  });

  test('bundles canonical and legacy auth fixture asset paths', () async {
    final canonicalJson =
        await rootBundle.loadString('assets/fixtures/auth/sample_accounts.json');
    final legacyFlatJson =
        await rootBundle.loadString('asset/fixtures/auth.sample_account.json');
    final legacyNestedJson =
        await rootBundle.loadString('asset/fixtures/auth/sample_accounts.json');

    expect(legacyFlatJson, canonicalJson);
    expect(legacyNestedJson, canonicalJson);
  });
}
