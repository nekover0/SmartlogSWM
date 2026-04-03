class ChangePasswordRequestDto {
  const ChangePasswordRequestDto({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}
