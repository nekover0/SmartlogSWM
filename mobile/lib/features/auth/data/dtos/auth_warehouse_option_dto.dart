class AuthWarehouseOptionDto {
  const AuthWarehouseOptionDto({
    required this.id,
    required this.code,
    required this.name,
  });

  final String id;
  final String code;
  final String name;

  factory AuthWarehouseOptionDto.fromJson(Map<String, dynamic> json) {
    return AuthWarehouseOptionDto(
      id: (json['id'] as String? ?? '').trim(),
      code: (json['code'] as String? ?? '').trim(),
      name: (json['name'] as String? ?? '').trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'code': code, 'name': name};
  }
}
