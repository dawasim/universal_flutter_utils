import 'package:permission_handler/permission_handler.dart';

class UFPermissionUtils {

  Future<bool> getAllPermissions() async {
    // Request permissions for storage, camera, gallery, and notification
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      Permission.photos,
      Permission.notification,
      Permission.location,
      Permission.contacts,
      Permission.audio,
      Permission.microphone,
      Permission.videos,
    ].request();

    // Check if all permissions are granted
    bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);

    if (allPermissionsGranted) {
      return true;
    } else {
      // Check which permissions are not granted and handle them
      for (var entry in statuses.entries) {
        if (!entry.value.isGranted) {
          // Handle the denied permissions here
          return false;
        }
      }
      return false;
    }
  }

  Future<bool> getStoragePermission() async {

    bool result = await _handlePermission(Permission.storage);
    PermissionStatus status = await Permission.storage.status;
    if(!result) {
      status = await Permission.manageExternalStorage.request();
    }
    return status.isGranted;
  }

  Future<bool> getCameraPermission() async {
    return await _handlePermission(Permission.camera);
  }

  Future<bool> getPhotosPermission() async {
    return await _handlePermission(Permission.photos);
  }

  Future<bool> getNotificationsPermission() async {
    return await _handlePermission(Permission.notification);
  }

  Future<bool> getLocationPermission() async {
    return await _handlePermission(Permission.location);
  }

  Future<bool> getContactsPermission() async {
    return await _handlePermission(Permission.contacts);
  }

  Future<bool> getAudioPermission() async {
    return await _handlePermission(Permission.audio);
  }

  Future<bool> getMicrophonePermission() async {
    return await _handlePermission(Permission.microphone);
  }

  Future<bool> getVideosPermission() async {
    return await _handlePermission(Permission.videos);
  }

  Future<bool> _handlePermission(Permission permission) async {
    PermissionStatus status = await permission.status;

    if (!status.isGranted) {
      status = await permission.request();
    }

    // Check WRITE_CONTACTS (only needed on Android, as iOS combines them)
    if (await permission.isPermanentlyDenied) {
      // Handle the case where the permission is permanently denied
      status = PermissionStatus.denied;
    } else if (!status.isGranted) {
      // Handle other denied statuses
      status = await permission.request();
    }

    return status.isGranted;
  }

  getContactPermissions() async {
    // Check and request READ_CONTACTS permission
    PermissionStatus readStatus = await Permission.contacts.status;
    if (!readStatus.isGranted) {
      readStatus = await Permission.contacts.request();
    }

    // Check WRITE_CONTACTS (only needed on Android, as iOS combines them)
    bool isPermanentlyDenied = await Permission.contacts.isPermanentlyDenied;
    if (isPermanentlyDenied) {
      // Handle the case where the permission is permanently denied
      readStatus = PermissionStatus.denied;
    } else if (!readStatus.isGranted) {
      // Handle other denied statuses
      readStatus = await Permission.contacts.request();
    }
    return readStatus.isGranted ;
  }

}