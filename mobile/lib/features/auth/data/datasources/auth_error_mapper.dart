import 'package:smartlog_swm_mobile/core/network/network_exception.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/errors/auth_exceptions.dart';

class AuthErrorMapper {
  const AuthErrorMapper();

  AuthException map(Object error) {
    if (error is AuthException) {
      return error;
    }

    if (error is NetworkResponseException) {
      return _mapResponseException(error);
    }

    if (error is NetworkTimeoutException ||
        error is NetworkConnectionException) {
      return const AuthNetworkException();
    }

    if (error is NetworkCancelledException) {
      return const AuthNetworkException('Yeu cau da bi huy. Vui long thu lai.');
    }

    if (error is NetworkUnexpectedException) {
      return const AuthServerException();
    }

    return const AuthServerException();
  }

  AuthException _mapResponseException(NetworkResponseException error) {
    switch (error.errorCode) {
      case 'AUTH_INVALID_CREDENTIALS':
        return const InvalidCredentialsException();
      case 'AUTH_ACCOUNT_INACTIVE':
        return const AccountInactiveException();
      case 'AUTH_ACCOUNT_LOCKED':
        return const AccountLockedException();
      case 'AUTH_REFRESH_INVALID':
        return const AuthRefreshInvalidException();
      case 'AUTH_REFRESH_EXPIRED':
        return const AuthRefreshExpiredException();
      case 'AUTH_REFRESH_REPLAY_DETECTED':
        return const AuthRefreshReplayDetectedException();
      case 'AUTH_SESSION_REVOKED':
        return const AuthSessionRevokedException();
      case 'AUTH_WAREHOUSE_CONTEXT_INVALID':
        return const AuthWarehouseContextInvalidException();
      case 'AUTH_PASSWORD_MISMATCH':
        return const AuthPasswordMismatchException();
      case 'AUTH_OLD_PASSWORD_INVALID':
        return const AuthOldPasswordInvalidException();
      case 'AUTH_PASSWORD_POLICY_VIOLATION':
        return const AuthPasswordPolicyViolationException();
      case 'AUTH_PASSWORD_REUSE_NOT_ALLOWED':
        return const AuthPasswordReuseNotAllowedException();
      case 'AUTH_SESSION_NOT_FOUND':
        return const AuthSessionNotFoundException();
    }

    switch (error.statusCode) {
      case 401:
        return const AuthUnauthorizedException();
      case 403:
        return const AuthForbiddenException();
      case 429:
        return const AuthRateLimitedException();
      default:
        if ((error.statusCode ?? 0) >= 500) {
          return const AuthServerException();
        }

        return AuthException(error.message, code: error.errorCode);
    }
  }
}
