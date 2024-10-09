// ignore_for_file: unused_element, unused_local_variable, unused_import

import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:loyaltylinx/main.dart';
import 'package:loyaltylinx/pages/auth/login.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:loyaltylinx/pages/veiws/profile.dart';
import 'package:loyaltylinx/pages/veiws/verification/additional_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const apiUrlValidateVerify =
    "https://loyalty-linxapi.vercel.app/api/user/validate-code-login";

String userCode = '';

class Authorization extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String code;
  final String sendVia;

  const Authorization({
    super.key,
    this.cameras,
    required this.code,
    required this.sendVia,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final _formKey = GlobalKey<FormState>();

  int _secondsRemaining = 300;
  Timer? _timer;

  Future<void> refreshCode(String apiRefreshCode, String token, context) async {
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
      sendOtp(widget.sendVia, context);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      final json = jsonDecode(response.body);
      // print(json);
    }
  }

  Future<void> sendOtp(mobileNo, context) async {
    var url = Uri.parse('https://loyalty-linxapi.vercel.app/api/user/send-otp');
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenMain',
        },
        body: jsonEncode({"number": mobileNo}));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Code successfully sent to ${widget.sendVia}')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Code failed to sent ${widget.sendVia}')));
      Navigator.of(context, rootNavigator: true).pop();
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessage(title: "Failed to verify", message: message);
    }
  }

  Future<void> _startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  bool clear = false;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> validate(value, context) async {
      showDialog(
          barrierColor: Theme.of(context).colorScheme.background,
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      var url = Uri.parse(
          'https://loyalty-linxapi.vercel.app/api/user/validate-code-with-token');
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $tokenMain',
          },
          body: jsonEncode({"secretCode": value}));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final message = json['message'];
        setState(() {
          userCode = value;
        });
        Navigator.pushReplacement(context, routeTransition(const AddForm()));
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        final json = jsonDecode(response.body);
        final message = json['message'];
        await showMessage(title: "Failed to verify", message: "Invalid Code");
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text(
          'Enter code',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text('We sent code via MobileNo to',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500)),
              Text(widget.sendVia,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade400,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 20),
              OtpTextField(
                borderColor: Theme.of(context).colorScheme.secondary,
                focusedBorderColor: Theme.of(context).colorScheme.secondary,
                numberOfFields: 6,
                showFieldAsBox: true,
                onCodeChanged: (value) {
                  setState(() {});
                },
                onSubmit: (value) {
                  setState(() {
                    clear = true;
                  });
                  validate(value, context);
                },
              ),
              const SizedBox(height: 20),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade900,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: _secondsRemaining > 0
                    ? null
                    : () {
                        // print(widget.code);
                        refreshCode(
                            'https://loyalty-linxapi.vercel.app/api/user/refresh-code',
                            tokenMain!,
                            context);
                        setState(() {
                          _secondsRemaining = 180;
                        });
                        _startTimer();
                      },
                child: _secondsRemaining > 0
                    ? Text(
                        'Resend OTP in ${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}')
                    : const Text(
                        'Resend',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

  PageRouteBuilder<dynamic> routeTransition(screenView) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => screenView,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
