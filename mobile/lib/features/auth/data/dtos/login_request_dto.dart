class LoginRequestDto {
  const LoginRequestDto({required this.username, required this.password});

  final String username;
  final String password;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'username': username, 'password': password};
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LoginRequestDto &&
            runtimeType == other.runtimeType &&
            username == other.username &&
            password == other.password;
  }

  @override
  int get hashCode => Object.hash(username, password);
}
