// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:loyaltylinx/main.dart';
import 'package:loyaltylinx/pages/auth/login.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OtpVerification extends StatefulWidget {
  final String sendMethod;
  final String apiUrlValidate;
  final Map<String, dynamic> token;
  final String mobileNo;
  const OtpVerification(
      {super.key,
      required this.sendMethod,
      required this.apiUrlValidate,
      required this.token,
      required this.mobileNo});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _secondsRemaining = 180;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel;
        }
      });
    });
  }

  bool clear = false;

  @override
  Widget build(BuildContext context) {
    Future<void> saveUserToken(Map<String, dynamic> objectToken) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', jsonEncode(objectToken));
    }

    Future<void> getProfile(
        String token, Map<String, dynamic> objectToken, context) async {
      final response = await http.get(
        Uri.parse(apiUrlProfile),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final userData = json['userProfile'];
        if (userData != null) {
          userData0 = [userData];
          tokenMain = objectToken['token'];
          Navigator.pushAndRemoveUntil(
              context,
              routeTransition(BottomNavBarExample(userData: [userData])),
              (route) => false);
          saveUserToken(objectToken);
        } else {
          debugPrint("its Empty");
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        final json = jsonDecode(response.body);
        final message = json['message'];
        await showMessage(title: "Failed to login", message: message);
      }
    }

    Future<void> validate(String token, Map<String, dynamic> objectToken,
        String code, context) async {
      var url = Uri.parse(
          'https://loyalty-linxapi.vercel.app/api/user/validate-code-login');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'secretCode': code}),
      );
      if (response.statusCode == 200) {
        // final json = jsonDecode(response.body);
        getProfile(token, objectToken, context);
      } else {
        // final json = jsonDecode(response.body);
        Navigator.of(context, rootNavigator: true).pop();
        await showMessage(title: "Failed to login", message: "Invalid Code");
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
              Text('We sent code via ${widget.sendMethod}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500)),
              Text(widget.mobileNo,
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
                onSubmit: (value) async {
                  showDialog(
                      barrierColor: Theme.of(context).colorScheme.background,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      });
                  final tokenOnly = widget.token['token'];
                  final tokenObject = widget.token;
                  final valueCode = value;
                  validate(tokenOnly, tokenObject, valueCode, context);
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
                onPressed: _secondsRemaining > 0 ? null : () {},
                child: _secondsRemaining > 0
                    ? Text(
                        "Resend OTP in ${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}")
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
