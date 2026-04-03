import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_warehouse_option_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

class LoginResponseDto {
  const LoginResponseDto({
    required this.accessToken,
    required this.user,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.sessionId,
    this.warehouseOptions = const <AuthWarehouseOptionDto>[],
    this.selectedWarehouseId,
    this.mustChangePassword = false,
  });

  final String accessToken;
  final AuthUser user;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final String? sessionId;
  final List<AuthWarehouseOptionDto> warehouseOptions;
  final String? selectedWarehouseId;
  final bool mustChangePassword;

  factory LoginResponseDto.fromApiJson(Map<String, dynamic> json) {
    final userPayload = _asMap(json['user']);

    final warehouseOptions =
        ((json['warehouseOptions'] as List?) ?? const <Object?>[])
            .whereType<Map>()
            .map(
              (Map<dynamic, dynamic> raw) => AuthWarehouseOptionDto.fromJson(
                raw.map(
                  (dynamic key, dynamic value) =>
                      MapEntry(key?.toString() ?? '', value),
                ),
              ),
            )
            .toList(growable: false);

    final selectedWarehouseId = (json['selectedWarehouseId'] as String?)
        ?.trim();
    final selectedWarehouse = _resolveSelectedWarehouse(
      options: warehouseOptions,
      selectedWarehouseId: selectedWarehouseId,
    );

    return LoginResponseDto(
      accessToken: (json['accessToken'] as String? ?? '').trim(),
      refreshToken: (json['refreshToken'] as String?)?.trim(),
      tokenType: (json['tokenType'] as String?)?.trim(),
      expiresIn: json['expiresIn'] as int?,
      sessionId: (json['sessionId'] as String?)?.trim(),
      user: AuthUser(
        id: (userPayload['id'] as String? ?? '').trim(),
        username:
            (userPayload['username'] as String? ??
                    userPayload['userCode'] as String? ??
                    '')
                .trim(),
        displayName:
            (userPayload['displayName'] as String? ??
                    userPayload['fullName'] as String? ??
                    '')
                .trim(),
        role: _resolveRole(userPayload),
        siteId: selectedWarehouse?.id ?? '',
        siteName: selectedWarehouse?.name ?? '',
      ),
      warehouseOptions: warehouseOptions,
      selectedWarehouseId:
          selectedWarehouseId != null && selectedWarehouseId.isNotEmpty
          ? selectedWarehouseId
          : null,
      mustChangePassword: userPayload['mustChangePassword'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      if (refreshToken != null) 'refreshToken': refreshToken,
      if (tokenType != null) 'tokenType': tokenType,
      if (expiresIn != null) 'expiresIn': expiresIn,
      if (sessionId != null) 'sessionId': sessionId,
      'user': user.toJson(),
      'warehouseOptions': warehouseOptions
          .map((AuthWarehouseOptionDto option) => option.toJson())
          .toList(growable: false),
      'selectedWarehouseId': selectedWarehouseId,
      'mustChangePassword': mustChangePassword,
    };
  }
}

Map<String, dynamic> _asMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map(
      (Object? key, Object? rawValue) =>
          MapEntry(key?.toString() ?? '', rawValue),
    );
  }

  return <String, dynamic>{};
}

String _resolveRole(Map<String, dynamic> userPayload) {
  final roleCodes = userPayload['roleCodes'];
  if (roleCodes is List) {
    for (final Object? value in roleCodes) {
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
  }

  final role = userPayload['role'];
  if (role is String && role.trim().isNotEmpty) {
    return role.trim();
  }

  return 'USER';
}

AuthWarehouseOptionDto? _resolveSelectedWarehouse({
  required List<AuthWarehouseOptionDto> options,
  required String? selectedWarehouseId,
}) {
  if (options.isEmpty) {
    return null;
  }

  if (selectedWarehouseId == null || selectedWarehouseId.isEmpty) {
    return options.first;
  }

  for (final AuthWarehouseOptionDto option in options) {
    if (option.id == selectedWarehouseId) {
      return option;
    }
  }

  return options.first;
}
