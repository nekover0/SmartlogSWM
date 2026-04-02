import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_warehouse_option_dto.dart';

class AuthProfileDto {
  const AuthProfileDto({
    required this.id,
    required this.userCode,
    required this.username,
    required this.fullName,
    this.email,
    required this.roleCodes,
    required this.selectedWarehouseId,
    required this.warehouseOptions,
    required this.ownerScope,
    required this.channel,
    required this.mustChangePassword,
  });

  final String id;
  final String userCode;
  final String username;
  final String fullName;
  final String? email;
  final List<String> roleCodes;
  final String? selectedWarehouseId;
  final List<AuthWarehouseOptionDto> warehouseOptions;
  final List<String> ownerScope;
  final String channel;
  final bool mustChangePassword;

  factory AuthProfileDto.fromJson(Map<String, dynamic> json) {
    return AuthProfileDto(
      id: (json['id'] as String? ?? '').trim(),
      userCode: (json['userCode'] as String? ?? '').trim(),
      username: (json['username'] as String? ?? '').trim(),
      fullName: (json['fullName'] as String? ?? '').trim(),
      email: (json['email'] as String?)?.trim(),
      roleCodes: _asStringList(json['roleCodes']),
      selectedWarehouseId: (json['selectedWarehouseId'] as String?)?.trim(),
      warehouseOptions: _asWarehouseOptions(json['warehouseOptions']),
      ownerScope: _asStringList(json['ownerScope']),
      channel: (json['channel'] as String? ?? '').trim(),
      mustChangePassword: json['mustChangePassword'] == true,
    );
  }
}

List<String> _asStringList(Object? value) {
  if (value is! List) {
    return const <String>[];
  }

  return value
      .whereType<String>()
      .map((String entry) => entry.trim())
      .where((String entry) => entry.isNotEmpty)
      .toList(growable: false);
}

List<AuthWarehouseOptionDto> _asWarehouseOptions(Object? value) {
  if (value is! List) {
    return const <AuthWarehouseOptionDto>[];
  }

  return value
      .whereType<Map>()
      .map(
        (Map<dynamic, dynamic> entry) => AuthWarehouseOptionDto.fromJson(
          entry.map(
            (dynamic key, dynamic rawValue) =>
                MapEntry(key?.toString() ?? '', rawValue),
          ),
        ),
      )
      .toList(growable: false);
}
