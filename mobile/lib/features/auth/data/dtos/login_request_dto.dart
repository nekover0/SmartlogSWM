enum AuthChannel {
  web('WEB'),
  mobile('MOBILE'),
  api('API');

  const AuthChannel(this.apiValue);

  final String apiValue;
}

class LoginRequestDto {
  const LoginRequestDto({
    required this.username,
    required this.password,
    this.channel = AuthChannel.mobile,
    this.deviceId,
    this.deviceName,
  });

  final String username;
  final String password;
  final AuthChannel channel;
  final String? deviceId;
  final String? deviceName;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'channel': channel.apiValue,
      if (deviceId != null && deviceId!.trim().isNotEmpty) 'deviceId': deviceId,
      if (deviceName != null && deviceName!.trim().isNotEmpty)
        'deviceName': deviceName,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LoginRequestDto &&
            runtimeType == other.runtimeType &&
            username == other.username &&
            password == other.password &&
            channel == other.channel &&
            deviceId == other.deviceId &&
            deviceName == other.deviceName;
  }

  @override
  int get hashCode =>
      Object.hash(username, password, channel, deviceId, deviceName);
}
