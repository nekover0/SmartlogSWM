class AuthPermissionsSnapshotDto {
  const AuthPermissionsSnapshotDto({
    required this.roleCodes,
    required this.permissions,
    required this.warehouseScope,
    required this.ownerScope,
  });

  final List<String> roleCodes;
  final List<String> permissions;
  final List<String> warehouseScope;
  final List<String> ownerScope;

  factory AuthPermissionsSnapshotDto.fromJson(Map<String, dynamic> json) {
    return AuthPermissionsSnapshotDto(
      roleCodes: _asStringList(json['roleCodes']),
      permissions: _asStringList(json['permissions']),
      warehouseScope: _asStringList(json['warehouseScope']),
      ownerScope: _asStringList(json['ownerScope']),
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
