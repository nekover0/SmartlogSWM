import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

enum CameraPermissionStatus { granted, denied }

abstract interface class PermissionService {
  Future<CameraPermissionStatus> getCameraPermissionStatus();

  Future<CameraPermissionStatus> requestCameraPermission();
}

final permissionServiceOverrideProvider = Provider<PermissionService?>((
  Ref<Object?> ref,
) {
  return null;
});

final platformPermissionServiceProvider = Provider<PermissionService>((
  Ref<Object?> ref,
) {
  return const PlatformPermissionService();
});

final permissionServiceProvider = Provider<PermissionService>((
  Ref<Object?> ref,
) {
  return ref.watch(permissionServiceOverrideProvider) ??
      ref.watch(platformPermissionServiceProvider);
});

class PlatformPermissionService implements PermissionService {
  const PlatformPermissionService();

  @override
  Future<CameraPermissionStatus> getCameraPermissionStatus() async {
    final status = await Permission.camera.status;
    return _mapPermissionStatus(status);
  }

  @override
  Future<CameraPermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return _mapPermissionStatus(status);
  }

  CameraPermissionStatus _mapPermissionStatus(PermissionStatus status) {
    if (status.isGranted || status.isLimited) {
      return CameraPermissionStatus.granted;
    }

    return CameraPermissionStatus.denied;
  }
}

class FakePermissionService implements PermissionService {
  const FakePermissionService({
    this.currentStatus = CameraPermissionStatus.granted,
    CameraPermissionStatus? requestStatus,
  }) : _requestStatus = requestStatus ?? currentStatus;

  final CameraPermissionStatus currentStatus;
  final CameraPermissionStatus _requestStatus;

  @override
  Future<CameraPermissionStatus> getCameraPermissionStatus() async {
    return currentStatus;
  }

  @override
  Future<CameraPermissionStatus> requestCameraPermission() async {
    return _requestStatus;
  }
}
