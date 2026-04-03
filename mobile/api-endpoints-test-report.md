# Mobile Auth Endpoints - Integration + Test Report

Generated: 2026-04-03
Scope: Endpoints currently wired in mobile runtime code.

## Endpoint List and Test Result

| # | Method | Endpoint | Integrated In | Test File | Test Case | Result |
|---|---|---|---|---|---|---|
| 1 | POST | /api/v1/auth/login | mobile/lib/features/auth/data/datasources/auth_api_client.dart | mobile/test/features/auth/data/datasources/auth_api_client_test.dart | login posts expected payload and maps response fields | PASS |
| 2 | POST | /api/v1/auth/refresh | mobile/lib/features/auth/data/datasources/auth_api_client.dart | mobile/test/features/auth/data/datasources/auth_api_client_test.dart | refresh calls expected endpoint | PASS |
| 3 | POST | /api/v1/auth/refresh | mobile/lib/core/network/auth_session_refresher.dart | mobile/test/core/network/auth_session_refresher_test.dart | executes refresh in single-flight mode | PASS |
| 4 | GET | /api/v1/auth/me | mobile/lib/features/auth/data/datasources/auth_api_client.dart | mobile/test/features/auth/data/datasources/auth_api_client_test.dart | getMe calls expected endpoint and maps profile | PASS |
| 5 | GET | /api/v1/auth/me/permissions | mobile/lib/features/auth/data/datasources/auth_api_client.dart | mobile/test/features/auth/data/datasources/auth_api_client_test.dart | getMyPermissions calls expected endpoint | PASS |
| 6 | GET | /api/v1/auth/sessions | mobile/lib/features/auth/data/datasources/auth_api_client.dart | mobile/test/features/auth/data/datasources/auth_api_client_test.dart | getSessions calls expected endpoint | PASS |
| 7 | POST | /api/v1/auth/change-password | mobile/lib/features/auth/data/datasources/auth_api_client.dart | mobile/test/features/auth/data/datasources/auth_api_client_test.dart | changePassword hits expected endpoint | PASS |
| 8 | POST | /api/v1/auth/select-warehouse | mobile/lib/features/auth/data/datasources/auth_api_client.dart | mobile/test/features/auth/data/datasources/auth_api_client_test.dart | selectWarehouse hits expected endpoint | PASS |
| 9 | POST | /api/v1/auth/sessions/{sessionId}/revoke | mobile/lib/features/auth/data/datasources/auth_api_client.dart | mobile/test/features/auth/data/datasources/auth_api_client_test.dart | revokeSession hits expected endpoint | PASS |
| 10 | POST | /api/v1/auth/logout | mobile/lib/features/auth/data/datasources/auth_api_client.dart | mobile/test/features/auth/data/datasources/auth_api_client_test.dart | logout hits expected endpoint | PASS |
| 11 | POST | /api/v1/auth/logout-all | mobile/lib/features/auth/data/datasources/auth_api_client.dart | mobile/test/features/auth/data/datasources/auth_api_client_test.dart | logoutAll hits expected endpoint | PASS |

## Extra Refresh Failure Coverage

These tests validate terminal refresh failure handling on /api/v1/auth/refresh:

- clears persisted session for terminal refresh failure: AUTH_REFRESH_INVALID -> PASS
- clears persisted session for terminal refresh failure: AUTH_REFRESH_EXPIRED -> PASS
- clears persisted session for terminal refresh failure: AUTH_REFRESH_REPLAY_DETECTED -> PASS
- clears persisted session for terminal refresh failure: AUTH_SESSION_REVOKED -> PASS

## Notes

- Endpoint discovery was done by scanning mobile/lib/** for /api/v1/.
- Current wired backend endpoints are Auth endpoints only.
