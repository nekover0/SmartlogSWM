import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';
import 'package:smartlog_swm_mobile/features/account/domain/models/account_admin_models.dart';

final accountAdminApiDataSourceProvider = Provider<AccountAdminApiDataSource>((
  Ref<Object?> ref,
) {
  return AccountAdminApiDataSource(httpClient: ref.watch(appHttpClientProvider));
});

class AccountAdminApiDataSource {
  AccountAdminApiDataSource({required AppHttpClient httpClient})
    : _httpClient = httpClient;

  static const String _rolesPath = '/api/v1/foundation/roles';
  static const String _usersPath = '/api/v1/foundation/users';
  static const String _authMePath = '/api/v1/auth/me';

  final AppHttpClient _httpClient;

  Future<List<AccountAdminRoleEntity>> getRoles() async {
    final payload = await _httpClient.getList(_rolesPath);

    return payload
        .map((entry) => _normalizeRole(_toMap(entry)))
        .toList(growable: false)
      ..sort((left, right) => left.roleName.compareTo(right.roleName));
  }

  Future<List<AccountAdminUserEntity>> getUsers() async {
    final foundationUsers = await _loadFoundationUsers();
    if (foundationUsers.isNotEmpty) {
      return foundationUsers;
    }

    final profile = await _httpClient.getMap(_authMePath);
    return <AccountAdminUserEntity>[_normalizeCurrentUserProfile(profile)];
  }

  Future<void> assignRoleToUser({
    required String userId,
    required String roleCode,
    String? warehouseCode,
    bool isPrimary = true,
  }) {
    return _httpClient.postVoid(
      '$_usersPath/${Uri.encodeComponent(userId)}/roles',
      data: <String, dynamic>{
        'roleCode': roleCode,
        if (warehouseCode != null && warehouseCode.trim().isNotEmpty)
          'warehouseCode': warehouseCode.trim(),
        'isPrimary': isPrimary,
      },
    );
  }

  Future<List<AccountAdminUserEntity>> _loadFoundationUsers() async {
    try {
      final payload = await _httpClient.getList(_usersPath);
      final users = payload
          .map((entry) => _normalizeFoundationUser(_toMap(entry)))
          .toList(growable: false)
        ..sort((left, right) => left.displayName.compareTo(right.displayName));
      return users;
    } catch (_) {
      return const <AccountAdminUserEntity>[];
    }
  }

  AccountAdminRoleEntity _normalizeRole(Map<String, dynamic> payload) {
    final roleCode =
        _stringFromKeys(payload, const <String>['roleCode', 'code']) ??
        'UNKNOWN';

    final roleName =
        _stringFromKeys(payload, const <String>['roleName', 'name']) ??
        _resolveRoleLabel(roleCode: roleCode, fallbackRoleName: null);

    final permissionCodes = _extractPermissionCodes(payload);

    return AccountAdminRoleEntity(
      id:
          _stringFromKeys(payload, const <String>['id']) ??
          'role-${roleCode.toLowerCase()}',
      roleCode: roleCode,
      roleName: roleName,
      description:
          _stringFromKeys(payload, const <String>['description']) ??
          'Chua co mo ta',
      isActive: _boolFromKeys(payload, const <String>['isActive', 'active']) ??
          true,
      permissionCodes: permissionCodes,
    );
  }

  AccountAdminUserEntity _normalizeFoundationUser(Map<String, dynamic> payload) {
    final roleCode = _extractRoleCode(payload) ?? 'UNKNOWN';
    final roleName = _extractRoleName(payload);
    final username =
        _stringFromKeys(payload, const <String>['username', 'userCode']) ??
        _stringFromKeys(payload, const <String>['email']) ??
        'unknown-user';

    final displayName =
        _stringFromKeys(payload, const <String>[
          'fullName',
          'displayName',
          'name',
        ]) ??
        username;

    return AccountAdminUserEntity(
      id:
          _stringFromKeys(payload, const <String>['id', 'userId']) ?? username,
      displayName: displayName,
      username: username,
      siteName: _resolveSiteName(payload),
      roleCode: roleCode,
      roleLabel:
          _resolveRoleLabel(roleCode: roleCode, fallbackRoleName: roleName),
      active: _resolveUserActive(payload),
      lastSeenLabel: _resolveLastSeenLabel(payload),
    );
  }

  AccountAdminUserEntity _normalizeCurrentUserProfile(
    Map<String, dynamic> payload,
  ) {
    final roleCodes = _asStringList(payload['roleCodes']);
    final primaryRoleCode = roleCodes.isEmpty ? 'UNKNOWN' : roleCodes.first;

    final username =
        _stringFromKeys(payload, const <String>['username', 'userCode']) ??
        'unknown-user';

    return AccountAdminUserEntity(
      id: _stringFromKeys(payload, const <String>['id']) ?? username,
      displayName:
          _stringFromKeys(payload, const <String>['fullName', 'displayName']) ??
          username,
      username: username,
      siteName: _resolveSiteName(payload),
      roleCode: primaryRoleCode,
      roleLabel: _resolveRoleLabel(
        roleCode: primaryRoleCode,
        fallbackRoleName: primaryRoleCode,
      ),
      active: true,
      lastSeenLabel: 'Dang hoat dong',
    );
  }

  List<String> _extractPermissionCodes(Map<String, dynamic> payload) {
    final rawPermissions = _listFromKeys(payload, const <String>[
      'permissions',
      'permissionCodes',
    ]);

    final permissionCodes = LinkedHashSet<String>();

    for (final entry in rawPermissions) {
      if (entry is String) {
        final normalized = entry.trim();
        if (normalized.isNotEmpty) {
          permissionCodes.add(normalized);
        }
        continue;
      }

      if (entry is! Map) {
        continue;
      }

      final map = _toMap(entry);
      final nestedPermission =
          _mapFromKeys(map, const <String>['permission']) ??
          const <String, dynamic>{};

      final permissionCode =
          _stringFromKeys(map, const <String>['permissionCode', 'code']) ??
          _stringFromKeys(
            nestedPermission,
            const <String>['permissionCode', 'code'],
          );

      if (permissionCode != null && permissionCode.isNotEmpty) {
        permissionCodes.add(permissionCode);
      }
    }

    return permissionCodes.toList(growable: false);
  }

  String? _extractRoleCode(Map<String, dynamic> payload) {
    final directRoleCode = _stringFromKeys(payload, const <String>['roleCode']);
    if (directRoleCode != null && directRoleCode.isNotEmpty) {
      return directRoleCode;
    }

    final roles = _listFromKeys(payload, const <String>['roles', 'userRoles']);
    for (final entry in roles) {
      if (entry is! Map) {
        continue;
      }

      final roleMap = _toMap(entry);
      final nestedRole =
          _mapFromKeys(roleMap, const <String>['role']) ??
          const <String, dynamic>{};

      final roleCode =
          _stringFromKeys(roleMap, const <String>['roleCode']) ??
          _stringFromKeys(nestedRole, const <String>['roleCode']);

      if (roleCode != null && roleCode.isNotEmpty) {
        return roleCode;
      }
    }

    return null;
  }

  String? _extractRoleName(Map<String, dynamic> payload) {
    final directRoleName =
        _stringFromKeys(payload, const <String>['roleName', 'roleLabel']);
    if (directRoleName != null && directRoleName.isNotEmpty) {
      return directRoleName;
    }

    final roles = _listFromKeys(payload, const <String>['roles', 'userRoles']);
    for (final entry in roles) {
      if (entry is! Map) {
        continue;
      }

      final roleMap = _toMap(entry);
      final nestedRole =
          _mapFromKeys(roleMap, const <String>['role']) ??
          const <String, dynamic>{};

      final roleName =
          _stringFromKeys(roleMap, const <String>['roleName', 'name']) ??
          _stringFromKeys(nestedRole, const <String>['roleName', 'name']);

      if (roleName != null && roleName.isNotEmpty) {
        return roleName;
      }
    }

    return null;
  }

  String _resolveSiteName(Map<String, dynamic> payload) {
    final selectedWarehouse =
        _mapFromKeys(payload, const <String>['selectedWarehouse']) ??
        const <String, dynamic>{};

    final selectedWarehouseName =
        _stringFromKeys(selectedWarehouse, const <String>['name', 'code']) ??
        _stringFromKeys(payload, const <String>['siteName', 'warehouseName']);

    if (selectedWarehouseName != null && selectedWarehouseName.isNotEmpty) {
      return selectedWarehouseName;
    }

    final selectedWarehouseId =
        _stringFromKeys(payload, const <String>['selectedWarehouseId']) ??
        _stringFromKeys(payload, const <String>['warehouseId', 'siteId']);

    final warehouseOptions = _listFromKeys(
      payload,
      const <String>['warehouseOptions'],
    );

    for (final option in warehouseOptions) {
      if (option is! Map) {
        continue;
      }

      final optionMap = _toMap(option);
      final optionId = _stringFromKeys(optionMap, const <String>['id']);
      final optionName =
          _stringFromKeys(optionMap, const <String>['name', 'code']) ??
          'Unknown site';

      if (selectedWarehouseId == null || optionId == selectedWarehouseId) {
        return optionName;
      }
    }

    return 'N/A';
  }

  bool _resolveUserActive(Map<String, dynamic> payload) {
    final active = _boolFromKeys(payload, const <String>['isActive', 'active']);
    if (active != null) {
      return active;
    }

    final status = _normalizeToken(
      _stringFromKeys(payload, const <String>['status']),
    );

    if (status.isEmpty) {
      return true;
    }

    return status != 'inactive' &&
        status != 'locked' &&
        status != 'disabled';
  }

  String _resolveLastSeenLabel(Map<String, dynamic> payload) {
    final rawDate =
        _stringFromKeys(payload, const <String>[
          'lastSeenAt',
          'lastLoginAt',
          'updatedAt',
          'createdAt',
        ]) ??
        _stringFromKeys(payload, const <String>[
          'last_seen_at',
          'last_login_at',
          'updated_at',
          'created_at',
        ]);

    final parsedDate = rawDate == null ? null : DateTime.tryParse(rawDate);
    if (parsedDate == null) {
      return 'Chua ro thoi diem';
    }

    final now = DateTime.now().toUtc();
    final delta = now.difference(parsedDate.toUtc());

    if (delta.inMinutes <= 1) {
      return 'Vua truy cap';
    }

    if (delta.inHours < 1) {
      return '${delta.inMinutes} phut truoc';
    }

    if (delta.inDays < 1) {
      return '${delta.inHours} gio truoc';
    }

    return '${delta.inDays} ngay truoc';
  }

  String _resolveRoleLabel({
    required String roleCode,
    required String? fallbackRoleName,
  }) {
    final normalizedCode = roleCode.trim();
    if (normalizedCode.isNotEmpty) {
      try {
        return AppRole.fromName(normalizedCode).label;
      } catch (_) {
        final fallback = fallbackRoleName?.trim();
        if (fallback != null && fallback.isNotEmpty) {
          return fallback;
        }

        return normalizedCode;
      }
    }

    final fallback = fallbackRoleName?.trim();
    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }

    return 'Unknown role';
  }

  Map<String, dynamic> _toMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return value.map(
        (Object? key, Object? nestedValue) =>
            MapEntry(key?.toString() ?? '', nestedValue),
      );
    }

    throw const FormatException('Account admin payload must be an object.');
  }

  String _normalizeToken(String? value) {
    if (value == null) {
      return '';
    }

    return value.trim().toLowerCase().replaceAll(RegExp(r'[_\-\s]+'), '');
  }

  List<dynamic> _listFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is List<dynamic>) {
        return value;
      }
      if (value is List) {
        return List<dynamic>.from(value);
      }
    }

    return const <dynamic>[];
  }

  Map<String, dynamic>? _mapFromKeys(
    Map<String, dynamic> map,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = map[key];
      if (value is Map<String, dynamic>) {
        return value;
      }
      if (value is Map) {
        return value.map(
          (Object? nestedKey, Object? nestedValue) =>
              MapEntry(nestedKey?.toString() ?? '', nestedValue),
        );
      }
    }

    return null;
  }

  String? _stringFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value == null) {
        continue;
      }

      if (value is String) {
        final normalized = value.trim();
        if (normalized.isNotEmpty) {
          return normalized;
        }
        continue;
      }

      final normalized = value.toString().trim();
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }

    return null;
  }

  bool? _boolFromKeys(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is bool) {
        return value;
      }
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true') {
          return true;
        }
        if (normalized == 'false') {
          return false;
        }
      }
      if (value is num) {
        return value != 0;
      }
    }

    return null;
  }

  List<String> _asStringList(Object? value) {
    if (value is! List) {
      return const <String>[];
    }

    final result = <String>[];
    for (final Object? entry in value) {
      if (entry == null) {
        continue;
      }

      final normalized = entry.toString().trim();
      if (normalized.isNotEmpty) {
        result.add(normalized);
      }
    }

    return result;
  }
}
