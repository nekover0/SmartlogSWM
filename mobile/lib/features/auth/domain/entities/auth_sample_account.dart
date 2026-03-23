import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

class AuthSampleAccount {
  const AuthSampleAccount({
    required this.id,
    required this.username,
    required this.password,
    required this.displayName,
    required this.role,
    required this.siteId,
    required this.siteName,
  });

  final String id;
  final String username;
  final String password;
  final String displayName;
  final String role;
  final String siteId;
  final String siteName;

  factory AuthSampleAccount.fromJson(Map<String, dynamic> json) {
    return AuthSampleAccount(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      displayName: json['displayName'] as String,
      role: json['role'] as String,
      siteId: json['siteId'] as String,
      siteName: json['siteName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'password': password,
      'displayName': displayName,
      'role': role,
      'siteId': siteId,
      'siteName': siteName,
    };
  }

  AuthUser toAuthUser() {
    return AuthUser(
      id: id,
      username: username,
      displayName: displayName,
      role: role,
      siteId: siteId,
      siteName: siteName,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthSampleAccount &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username &&
            password == other.password &&
            displayName == other.displayName &&
            role == other.role &&
            siteId == other.siteId &&
            siteName == other.siteName;
  }

  @override
  int get hashCode =>
      Object.hash(id, username, password, displayName, role, siteId, siteName);
}
