// ignore_for_file: deprecated_member_use, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:screenshot/screenshot.dart';
import 'package:http/http.dart' as http;
import 'package:unicons/unicons.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import '../../main.dart';

class MyQrPage extends StatefulWidget {
  const MyQrPage({super.key});

  @override
  State<MyQrPage> createState() => _MyQrPageState();
}

String? qrCodeNum;

class _MyQrPageState extends State<MyQrPage> {
  QRViewController? controller;

  // var screenshotController = ScreenshotController();

  Barcode? result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    qrCodeNum = userData1[0]['qrCode'];
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

  // Future<void> _saveQRCodeToGallery(BuildContext context) async {
  //   // showDialog(
  //   //     barrierColor: Theme.of(context).colorScheme.background,
  //   //     barrierDismissible: false,
  //   //     context: context,
  //   //     builder: (context) {
  //   //       return const Center(child: CircularProgressIndicator());
  //   //     });
  //   try {
  //     // Delay to ensure the QR code is fully rendered
  //     await Future.delayed(const Duration(milliseconds: 200));
  //     // Capture the QR code image
  //     // Uint8List? imageBytes = await screenshotController.capture();

  //     // Save the image to the gallery
  //     final result = await ImageGallerySaver.saveImage(imageBytes!);
  //     if (result['isSuccess']) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('QR code saved to gallery'),
  //       ));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Failed to save QR code to gallery'),
  //       ));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Failed to save QR code: $e'),
  //     ));
  //   }
  //   // Future.delayed(const Duration(seconds: 2), () {
  //   //   Navigator.of(context, rootNavigator: true).pop();
  //   // });
  // }

  Widget _buildBody(context) {
    return Column(
      children: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height / 2.2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Text("data"),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: QrImageView(
                              data: '$qrCodeNum',
                              version: QrVersions.auto,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Save image"),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                            onPressed: () async {
                              // _saveQRCodeToGallery(context);
                            },
                            child: Icon(
                              Icons.save_alt,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Generate QR"),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                            onPressed: () async {
                              refreshCodeQr(
                                  'https://loyalty-linxapi.vercel.app/api/user/refresh-qr',
                                  tokenMain!,
                                  context);
                            },
                            child: Icon(
                              UniconsLine.history_alt,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            )),
                      ),
                    ],
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
