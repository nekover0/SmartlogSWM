import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((
  Ref<Object?> ref,
) {
  return FlutterSecureStorageService();
});
