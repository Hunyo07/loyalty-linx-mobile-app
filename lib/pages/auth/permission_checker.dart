import 'package:permission_handler/permission_handler.dart';

// ignore: non_constant_identifier_names
Permission_checker() async {
  await Permission.storage.request();
}
