import 'package:permission_handler/permission_handler.dart';

import 'debug.dart';

class PermissionUtility {
  static Future<void> requiredPermissionsList ({required List<Permission> permissions}) async{
    for(Permission p in permissions) {
      await requiredPermission(permission: p);
    }
  }

  static Future<void> requiredPermission({required Permission permission}) async {
    bool isGranted = await permission.isGranted;
    int count = 0;
    while(!isGranted) {
      PermissionStatus permissionStatus = await permission.request();
      isGranted = permissionStatus.isGranted;
      count++;
      if(count  == 10) {
        break;
      }
    }
    Debug.printing("Permission ${permission.toString()}: granted $isGranted");
  }
}