class AuthRefreshResponseDto {
  const AuthRefreshResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.sessionId,
  });

  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String sessionId;

  factory AuthRefreshResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthRefreshResponseDto(
      accessToken: (json['accessToken'] as String? ?? '').trim(),
      refreshToken: (json['refreshToken'] as String? ?? '').trim(),
      expiresIn: (json['expiresIn'] as int?) ?? 0,
      sessionId: (json['sessionId'] as String? ?? '').trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'sessionId': sessionId,
    };
  }
}
