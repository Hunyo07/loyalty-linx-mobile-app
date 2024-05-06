import 'package:flutter/material.dart';

class Verification extends StatefulWidget {
  final String passWord;
  final String mobileNo;
  final String email;
  final String apiUrlValidate;
  const Verification(
      {super.key,
      required this.email,
      required this.mobileNo,
      required this.passWord,
      required this.apiUrlValidate});

  @override
  State<Verification> createState() => _VerificationState();
}

// var _sendVia = 'Email';

enum SingingCharacter { mobileNumber, email }

Future<void> sendMethod(context, widget) async {
  // Navigator.of(context).pushAndRemoveUntil(
  //     routeTransition(OtpVerification(
  //         apiUrlValidate: widget.apiUrlValidate,
  //         email: widget.email,
  //         passWord: widget.passWord,
  //         sendMethod: _sendVia,
  //         sendTo: _sendVia == 'Email' ? widget.email : widget.mobileNo)),
  //     (Route<dynamic> route) => false);
}

SingingCharacter? _character = SingingCharacter.email;

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: verificationMethod(context),
    );
  }

  Container verificationMethod(BuildContext context) {
    return Container(
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
                setState(() {
                  // _sendVia = "Email";
                  _character = value;
                });
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
                  // _sendVia = "MobileNo";
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
                showDialog(
                    barrierColor: Theme.of(context).colorScheme.background,
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return const Center(child: CircularProgressIndicator());
                    });
                sendMethod(context, widget);
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
    );
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
