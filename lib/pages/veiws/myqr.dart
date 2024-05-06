// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyaltylinx/main.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class MyQrPage extends StatefulWidget {
  const MyQrPage({super.key});

  @override
  State<MyQrPage> createState() => _MyQrPageState();
}

String? qrCodeNum;

class _MyQrPageState extends State<MyQrPage> {
  QRViewController? controller;

  final screenshotController = ScreenshotController();

  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_token');

    if (data != null) {
      final json = jsonDecode(data);
      setState(() {
        qrCodeNum = json['userId'] + userData1[0]['qrCode'];
      });
    }
  }

  Barcode? result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Future<void> refreshCodeQr(
      String apiRefreshCode, String token, context) async {
    var url = Uri.parse(apiRefreshCode);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // final message = json['message'];
      setState(() {
        qrCodeNum = json['qrCode'];
      });
    } else {
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessage(title: "Failed to generate qr", message: message);
    }
  }

  Widget _buildBody(context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDark = brightness == Brightness.dark;
    return Column(
      children: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white
                              : const Color.fromARGB(255, 0, 12, 30),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child: Screenshot(
                              controller: screenshotController,
                              child: QrImageView(size: 300, data: '$qrCodeNum'),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )),
        FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: isDark
                                ? Colors.white
                                : const Color.fromARGB(255, 0, 12, 30)),
                        onPressed: () async {
                          final directory = await getExternalStorageDirectory();
                          final imagePath = '${directory!.path}/qr_code.png';
                          final imageFile = File(imagePath);
                          final imageBytes =
                              await screenshotController.capture();
                          await imageFile.writeAsBytes(imageBytes!);
                          await ImageGallerySaver.saveImage(imageBytes);
                        },
                        child: Icon(
                          Icons.save_alt,
                          color: !isDark ? Colors.white : Colors.black,
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: isDark
                                ? Colors.white
                                : const Color.fromARGB(255, 0, 12, 30)),
                        onPressed: () async {
                          debugPrint("Generate");
                          refreshCodeQr(
                              'https://loyaltylinx.cyclic.app/api/user/refresh-qr',
                              tokenMain!,
                              context);
                        },
                        child: Icon(
                          Icons.qr_code_scanner_sharp,
                          color: !isDark ? Colors.white : Colors.black,
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  showMessage({required String title, required String message}) {
    showCupertinoDialog(
        context: context,
        builder: (contex) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: const Text("ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
