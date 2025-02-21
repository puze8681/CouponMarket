import 'package:permission_handler/permission_handler.dart';

PermissionService permissionManager = PermissionManager();
abstract class PermissionService {
  bool isInitialized();

  Future<void> init();
  Future<List<Permission>> checkPermission();
  Future<List<Permission>> requestPermission({List<Permission>? permissionList});
}

class PermissionManager extends PermissionService {
  List<Permission>? permissionList;

  PermissionManager({this.permissionList});

  @override
  bool isInitialized(){
    return permissionList != null;
  }

  @override
  Future<void> init() async {
    List<Permission> permissions = [];
    permissions.add(Permission.bluetoothScan);
    permissions.add(Permission.bluetoothConnect);
    permissions.add(Permission.notification);
    permissions.add(Permission.location);
    
    permissionList = [...permissions];
  }

  @override
  Future<List<Permission>> checkPermission() async {
    List<Permission> permissions = this.permissionList!;
    try {
      List<Permission> deniedPermissions = [];
      for (int i = 0; i < permissions.length; i++) {
        var permission = permissions[i];
        var status = await permission.status;

        if(!status.isGranted){
          deniedPermissions.add(permission);
        }
      }
      return deniedPermissions;
    } catch (e) {
      return permissions;
    }
  }

  @override
  Future<List<Permission>> requestPermission({List<Permission>? permissionList}) async {
    try {
      List<Permission> permissions = permissionList ?? this.permissionList!;
      List<Permission> deniedPermissions = [];
      for (int i = 0; i < permissions.length; i++) {
        var permission = permissions[i];
        var status = await permission.request();

        if(status.isPermanentlyDenied){
          await openAppSettings();
        }
        if(!status.isGranted){
          deniedPermissions.add(permission);
        }
      }
      return deniedPermissions;
    } catch (e) {
      return permissionList ?? this.permissionList!;
    }
  }
}
