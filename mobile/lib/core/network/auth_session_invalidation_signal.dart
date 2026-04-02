import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authSessionInvalidationSignalProvider =
    ChangeNotifierProvider<AuthSessionInvalidationSignal>(
      (Ref<Object?> ref) => AuthSessionInvalidationSignal(),
    );

class AuthSessionInvalidationSignal extends ChangeNotifier {
  int _version = 0;

  int get version => _version;

  void markInvalidated() {
    _version += 1;
    notifyListeners();
  }
}
