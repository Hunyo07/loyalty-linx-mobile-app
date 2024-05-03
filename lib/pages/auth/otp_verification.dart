import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:loyaltylinx/pages/auth/login.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OtpVerification extends StatefulWidget {
  final String passWord;
  final String sendMethod;
  final String sendTo;
  final String email;
  final String apiUrlLogin;
  final String apiUrlValidate;

  const OtpVerification(
      {super.key,
      required this.sendMethod,
      required this.passWord,
      required this.sendTo,
      required this.email,
      required this.apiUrlLogin,
      required this.apiUrlValidate});

  @override
  // ignore: library_private_types_in_public_api
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _formKey = GlobalKey<FormState>();

  bool clear = false;

  @override
  Widget build(BuildContext context) {
    Future<void> saveUserData(Map<String, dynamic> userData) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(userData));
    }

    Future<void> saveUserRigester(Map<String, dynamic> userRegister) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_register', jsonEncode(userRegister));
    }

    Future<void> saveUserToken(userToken) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', jsonEncode(userToken));
    }

    Future<void> getProfile(String token, context) async {
      final response = await http.get(
        Uri.parse(apiUrlProfile),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final userData = json['userProfile'];
        Navigator.pushAndRemoveUntil(
            context,
            routeTransition(BottomNavBarExample(userData: [userData])),
            (route) => false);
        saveUserToken(token);
        saveUserData(json);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        final json = jsonDecode(response.body);
        final message = json['message'];
        await showMessage(title: "Failed to login", message: message);
      }
    }

    Future validate(String token, code, context) async {
      var url = Uri.parse(widget.apiUrlValidate);
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'secretCode': "$code"}),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        saveUserRigester(json);
        getProfile(token, context);
      } else {
        final json = jsonDecode(response.body);
        debugPrint(json.toString());
        Navigator.of(context, rootNavigator: true).pop();
        await showMessage(title: "Failed to login", message: "Invalid code");
      }
    }

    Future login(String email, String password, String code, context) async {
      final response = await http.post(
        Uri.parse(apiUrlLogin),
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({'email': email, 'password': password, 'role': 'user'}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['token'];
        final code1 = json['userCode'];
        validate(token, code, context);
        debugPrint(code1);
      } else {
        final json = jsonDecode(response.body);
        final message = json['message'];
        await showMessage(title: "Failed to login", message: message);
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
              Text('We sent code via ${widget.sendMethod} to',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500)),
              Text(widget.sendTo,
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
                  showDialog(
                      barrierColor: Theme.of(context).colorScheme.background,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      });
                  setState(() {
                    clear = true;
                  });
                  login(widget.email, widget.passWord, value, context);
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
                onPressed: () {
                  // debugPrint(widget.secretCode);
                },
                child: const Text(
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
