import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';

class ShipmentFixtureNotFoundException implements Exception {
  const ShipmentFixtureNotFoundException(this.shipmentId);

  final String shipmentId;

  @override
  String toString() => 'Shipment fixture not found for "$shipmentId".';
}

class ShipmentFixtureDataSource {
  ShipmentFixtureDataSource({
    AssetBundle? assetBundle,
    this.listFixturePath = _defaultListFixturePath,
    Map<String, String>? detailFixturePaths,
  }) : _assetBundle = assetBundle ?? rootBundle,
       detailFixturePaths = detailFixturePaths ?? _defaultDetailFixturePaths;

  static const String _defaultListFixturePath =
      'assets/fixtures/outbound/shipment_list.json';

  static const Map<String, String> _defaultDetailFixturePaths =
      <String, String>{
        'shp-20260324-001':
            'assets/fixtures/outbound/shipment_detail_shipment-001.json',
      };

  final AssetBundle _assetBundle;
  final String listFixturePath;
  final Map<String, String> detailFixturePaths;

  List<ShipmentDto>? _cachedShipments;
  final Map<String, ShipmentDto> _cachedShipmentDetails =
      <String, ShipmentDto>{};

  Future<List<ShipmentDto>> getShipmentList() async {
    if (_cachedShipments != null) {
      return _cachedShipments!;
    }

    final rawJson = await _assetBundle.loadString(listFixturePath);
    final payload = jsonDecode(rawJson) as Map<String, dynamic>;
    final shipmentsJson = payload['shipments'] as List<dynamic>;

    _cachedShipments = shipmentsJson
        .map((entry) => ShipmentDto.fromJson(entry as Map<String, dynamic>))
        .toList(growable: false);

    return _cachedShipments!;
  }

  Future<ShipmentDto> getShipmentDetail(String shipmentId) async {
    final cachedDetail = _cachedShipmentDetails[shipmentId];
    if (cachedDetail != null) {
      return cachedDetail;
    }

    final detailFixturePath = detailFixturePaths[shipmentId];
    if (detailFixturePath != null) {
      final detail = await _loadDetailFromPath(detailFixturePath);
      _cachedShipmentDetails[shipmentId] = detail;
      return detail;
    }

    final listShipment = await _findShipmentInList(shipmentId);
    if (listShipment != null) {
      return listShipment;
    }

    throw ShipmentFixtureNotFoundException(shipmentId);
  }

  Future<ShipmentDto?> _findShipmentInList(String shipmentId) async {
    final shipments = await getShipmentList();
    return shipments.cast<ShipmentDto?>().firstWhere(
      (shipment) => shipment?.id == shipmentId,
      orElse: () => null,
    );
  }

  Future<ShipmentDto> _loadDetailFromPath(String fixturePath) async {
    final rawJson = await _assetBundle.loadString(fixturePath);
    final payload = jsonDecode(rawJson) as Map<String, dynamic>;
    final shipmentJson = payload['shipment'] as Map<String, dynamic>;
    return ShipmentDto.fromJson(shipmentJson);
  }
}
