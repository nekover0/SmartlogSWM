class AuthSessionSummaryDto {
  const AuthSessionSummaryDto({
    required this.id,
    required this.sessionCode,
    required this.channel,
    this.deviceName,
    this.ipAddress,
    this.loginAt,
    this.lastSeenAt,
    required this.isCurrent,
  });

  final String id;
  final String sessionCode;
  final String channel;
  final String? deviceName;
  final String? ipAddress;
  final DateTime? loginAt;
  final DateTime? lastSeenAt;
  final bool isCurrent;

  factory AuthSessionSummaryDto.fromJson(Map<String, dynamic> json) {
    return AuthSessionSummaryDto(
      id: (json['id'] as String? ?? '').trim(),
      sessionCode: (json['sessionCode'] as String? ?? '').trim(),
      channel: (json['channel'] as String? ?? '').trim(),
      deviceName: (json['deviceName'] as String?)?.trim(),
      ipAddress: (json['ipAddress'] as String?)?.trim(),
      loginAt: _parseDateTime(json['loginAt']),
      lastSeenAt: _parseDateTime(json['lastSeenAt']),
      isCurrent: json['isCurrent'] == true,
    );
  }
}

DateTime? _parseDateTime(Object? value) {
  if (value is! String || value.trim().isEmpty) {
    return null;
  }

  return DateTime.tryParse(value)?.toUtc();
}
