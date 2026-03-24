import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CameraPermissionStatus { granted, denied }

abstract interface class PermissionService {
  Future<CameraPermissionStatus> getCameraPermissionStatus();

  Future<CameraPermissionStatus> requestCameraPermission();
}

final permissionServiceProvider = Provider<PermissionService>((Ref<Object?> ref) {
  return const FakePermissionService();
});

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
