import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

class LoginResponseDto {
  const LoginResponseDto({required this.accessToken, required this.user});

  final String accessToken;
  final AuthUser user;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'accessToken': accessToken, 'user': user.toJson()};
  }
}
