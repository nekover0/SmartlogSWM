import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.sessionId,
    this.tokenType,
    required this.currentUser,
    required this.loggedInAt,
    required this.persistedAt,
  });

  final String accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final String? sessionId;
  final String? tokenType;
  final AuthUser currentUser;
  final DateTime loggedInAt;
  final DateTime persistedAt;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: json['expiresIn'] as int?,
      sessionId: json['sessionId'] as String?,
      tokenType: json['tokenType'] as String?,
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
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'sessionId': sessionId,
      'tokenType': tokenType,
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
            refreshToken == other.refreshToken &&
            expiresIn == other.expiresIn &&
            sessionId == other.sessionId &&
            tokenType == other.tokenType &&
            currentUser == other.currentUser &&
            loggedInAt == other.loggedInAt &&
            persistedAt == other.persistedAt;
  }

  @override
  int get hashCode => Object.hash(
    accessToken,
    refreshToken,
    expiresIn,
    sessionId,
    tokenType,
    currentUser,
    loggedInAt,
    persistedAt,
  );
}
