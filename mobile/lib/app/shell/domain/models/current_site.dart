import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

class CurrentSite {
  const CurrentSite({required this.id, required this.name});

  final String id;
  final String name;

  factory CurrentSite.fromUser(AuthUser user) {
    final normalizedName = user.siteName.trim().isEmpty
        ? 'Smartlog WMS'
        : user.siteName.trim();

    return CurrentSite(id: user.siteId, name: normalizedName);
  }

  String get label => name;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CurrentSite &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
