class SelectWarehouseResponseDto {
  const SelectWarehouseResponseDto({
    required this.selectedWarehouseId,
    required this.accessToken,
  });

  final String selectedWarehouseId;
  final String accessToken;

  factory SelectWarehouseResponseDto.fromJson(Map<String, dynamic> json) {
    return SelectWarehouseResponseDto(
      selectedWarehouseId: (json['selectedWarehouseId'] as String? ?? '')
          .trim(),
      accessToken: (json['accessToken'] as String? ?? '').trim(),
    );
  }
}
