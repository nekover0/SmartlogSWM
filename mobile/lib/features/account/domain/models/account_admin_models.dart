class AccountAdminUserEntity {
  const AccountAdminUserEntity({
    required this.id,
    required this.displayName,
    required this.username,
    required this.siteName,
    required this.roleCode,
    required this.roleLabel,
    required this.active,
    required this.lastSeenLabel,
  });

  final String id;
  final String displayName;
  final String username;
  final String siteName;
  final String roleCode;
  final String roleLabel;
  final bool active;
  final String lastSeenLabel;

  String get initials {
    final name = displayName.trim();
    if (name.isEmpty) {
      return 'NA';
    }

    final segments = name.split(RegExp(r'\s+'));
    if (segments.length == 1) {
      final token = segments.first.trim();
      return token.isEmpty ? 'NA' : token.substring(0, 1).toUpperCase();
    }

    return '${segments.first[0]}${segments.last[0]}'.toUpperCase();
  }
}

class AccountAdminRoleEntity {
  const AccountAdminRoleEntity({
    required this.id,
    required this.roleCode,
    required this.roleName,
    required this.description,
    required this.isActive,
    required this.permissionCodes,
  });

  final String id;
  final String roleCode;
  final String roleName;
  final String description;
  final bool isActive;
  final List<String> permissionCodes;
}
