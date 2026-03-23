class AuthUser {
  const AuthUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.siteId,
    required this.siteName,
  });

  final String id;
  final String username;
  final String displayName;
  final String role;
  final String siteId;
  final String siteName;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      username: json['username'] as String,
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
      'displayName': displayName,
      'role': role,
      'siteId': siteId,
      'siteName': siteName,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthUser &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            username == other.username &&
            displayName == other.displayName &&
            role == other.role &&
            siteId == other.siteId &&
            siteName == other.siteName;
  }

  @override
  int get hashCode =>
      Object.hash(id, username, displayName, role, siteId, siteName);
}
