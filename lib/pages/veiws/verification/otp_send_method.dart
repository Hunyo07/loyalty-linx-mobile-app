import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyaltylinx/main.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:loyaltylinx/pages/veiws/verification/authorization.dart';
import 'package:http/http.dart' as http;

class ApplyCreditOtp extends StatefulWidget {
  final String userCode;
  const ApplyCreditOtp({super.key, required this.userCode});

  @override
  State<ApplyCreditOtp> createState() => _ApplyCreditOtpState();
}

enum SingingCharacter { mobileNumber, email }

String? codeOtp;

SingingCharacter? _character = SingingCharacter.mobileNumber;
var _sendVia = 'MobileNo';

class _ApplyCreditOtpState extends State<ApplyCreditOtp> {
  Future<void> sendMethod(context, widget) async {
    Navigator.of(context).pushAndRemoveUntil(
        routeTransition(Authorization(
          code: widget.userCode,
          sendVia: _sendVia == 'Email'
              ? userData1[0]['email']
              : userData1[0]['mobileNo'],
        )),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    codeOtp = widget.userCode;
    super.initState();
  }

  Future<void> sendOtp(mobileNo, context) async {
    showDialog(
        barrierColor: Theme.of(context).colorScheme.background,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    var url = Uri.parse('https://loyaltylinx.cyclic.app/api/user/send-otp');
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenMain',
        },
        body: jsonEncode({"number": mobileNo}));

    if (response.statusCode == 200) {
      // final json = jsonDecode(response.body);
      // final message = json;
      // print(message);
      Navigator.of(context).pushAndRemoveUntil(
          routeTransition(Authorization(
            code: widget.userCode,
            sendVia: _sendVia == 'Email'
                ? userData1[0]['email']
                : userData1[0]['mobileNo'],
          )),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessage(title: "Failed to verify", message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
        child: Column(
          children: <Widget>[
            const Row(
              children: [
                Text(
                  "Send code via",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Email"),
              leading: Radio<SingingCharacter>(
                onChanged: (SingingCharacter? value) {
                  showMessage(
                      title: "Opps!",
                      message: "Sending via email is not supported yet");
                  // setState(() {
                  //   _sendVia = "Email";
                  //   _character = value;
                  // });
                },
                value: SingingCharacter.email,
                groupValue: _character,
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Mobile number"),
              leading: Radio<SingingCharacter>(
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _sendVia = "MobileNo";
                    _character = value;
                  });
                },
                value: SingingCharacter.mobileNumber,
                groupValue: _character,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade900,
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () async {
                  // showDialog(
                  //     barrierColor: Theme.of(context).colorScheme.background,
                  //     barrierDismissible: false,
                  //     context: context,
                  //     builder: (context) {
                  //       return const Center(child: CircularProgressIndicator());
                  //     });
                  // sendMethod(context, widget);
                  // print(tokenMain);
                  sendOtp(userData1[0]['mobileNo'], context);
                  // print('tokenMain');
                },
                child: const Text(
                  "Send",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                )),
            const SizedBox(height: 20)
          ],
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
