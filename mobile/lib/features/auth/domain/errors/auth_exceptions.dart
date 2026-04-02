class AuthException implements Exception {
  const AuthException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([
    super.message = 'Sai ten dang nhap hoac mat khau.',
  ]) : super(code: 'AUTH_INVALID_CREDENTIALS');
}

class AccountInactiveException extends AuthException {
  const AccountInactiveException([
    super.message = 'Tai khoan da bi vo hieu hoa.',
  ]) : super(code: 'AUTH_ACCOUNT_INACTIVE');
}

class AccountLockedException extends AuthException {
  const AccountLockedException([
    super.message = 'Tai khoan dang bi khoa tam thoi.',
  ]) : super(code: 'AUTH_ACCOUNT_LOCKED');
}

class AuthRefreshInvalidException extends AuthException {
  const AuthRefreshInvalidException([
    super.message = 'Refresh token khong hop le.',
  ]) : super(code: 'AUTH_REFRESH_INVALID');
}

class AuthRefreshExpiredException extends AuthException {
  const AuthRefreshExpiredException([
    super.message = 'Refresh token da het han.',
  ]) : super(code: 'AUTH_REFRESH_EXPIRED');
}

class AuthRefreshReplayDetectedException extends AuthException {
  const AuthRefreshReplayDetectedException([
    super.message = 'Phat hien replay refresh token. Vui long dang nhap lai.',
  ]) : super(code: 'AUTH_REFRESH_REPLAY_DETECTED');
}

class AuthSessionRevokedException extends AuthException {
  const AuthSessionRevokedException([
    super.message = 'Session da het hieu luc. Vui long dang nhap lai.',
  ]) : super(code: 'AUTH_SESSION_REVOKED');
}

class AuthWarehouseContextInvalidException extends AuthException {
  const AuthWarehouseContextInvalidException([
    super.message = 'Kho duoc chon khong hop le hoac ban khong co quyen.',
  ]) : super(code: 'AUTH_WAREHOUSE_CONTEXT_INVALID');
}

class AuthPasswordMismatchException extends AuthException {
  const AuthPasswordMismatchException([
    super.message = 'Mat khau xac nhan khong khop.',
  ]) : super(code: 'AUTH_PASSWORD_MISMATCH');
}

class AuthOldPasswordInvalidException extends AuthException {
  const AuthOldPasswordInvalidException([
    super.message = 'Mat khau cu khong chinh xac.',
  ]) : super(code: 'AUTH_OLD_PASSWORD_INVALID');
}

class AuthPasswordPolicyViolationException extends AuthException {
  const AuthPasswordPolicyViolationException([
    super.message = 'Mat khau moi khong dat yeu cau bao mat.',
  ]) : super(code: 'AUTH_PASSWORD_POLICY_VIOLATION');
}

class AuthPasswordReuseNotAllowedException extends AuthException {
  const AuthPasswordReuseNotAllowedException([
    super.message = 'Khong duoc su dung lai mat khau cu.',
  ]) : super(code: 'AUTH_PASSWORD_REUSE_NOT_ALLOWED');
}

class AuthSessionNotFoundException extends AuthException {
  const AuthSessionNotFoundException([
    super.message = 'Session khong ton tai hoac da bi thu hoi.',
  ]) : super(code: 'AUTH_SESSION_NOT_FOUND');
}

class AuthUnauthorizedException extends AuthException {
  const AuthUnauthorizedException([
    super.message = 'Phien dang nhap khong hop le. Vui long dang nhap lai.',
  ]) : super(code: 'AUTH_UNAUTHORIZED');
}

class AuthForbiddenException extends AuthException {
  const AuthForbiddenException([
    super.message = 'Ban khong co quyen thuc hien thao tac nay.',
  ]) : super(code: 'AUTH_FORBIDDEN');
}

class AuthRateLimitedException extends AuthException {
  const AuthRateLimitedException([
    super.message = 'Ban da thao tac qua nhanh. Vui long thu lai sau.',
  ]) : super(code: 'AUTH_RATE_LIMITED');
}

class AuthNetworkException extends AuthException {
  const AuthNetworkException([
    super.message = 'Khong the ket noi den may chu. Vui long thu lai.',
  ]) : super(code: 'AUTH_NETWORK_ERROR');
}

class AuthServerException extends AuthException {
  const AuthServerException([
    super.message = 'He thong tam thoi gian doan. Vui long thu lai sau.',
  ]) : super(code: 'AUTH_SERVER_ERROR');
}
