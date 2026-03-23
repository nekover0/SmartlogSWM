import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.currentUser,
    required this.loggedInAt,
    required this.persistedAt,
  });

  final String accessToken;
  final AuthUser currentUser;
  final DateTime loggedInAt;
  final DateTime persistedAt;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String,
      currentUser: AuthUser.fromJson(
        json['currentUser'] as Map<String, dynamic>,
      ),
      loggedInAt: DateTime.parse(json['loggedInAt'] as String),
      persistedAt: DateTime.parse(json['persistedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'currentUser': currentUser.toJson(),
      'loggedInAt': loggedInAt.toUtc().toIso8601String(),
      'persistedAt': persistedAt.toUtc().toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthSession &&
            runtimeType == other.runtimeType &&
            accessToken == other.accessToken &&
            currentUser == other.currentUser &&
            loggedInAt == other.loggedInAt &&
            persistedAt == other.persistedAt;
  }

  @override
  int get hashCode =>
      Object.hash(accessToken, currentUser, loggedInAt, persistedAt);
}
