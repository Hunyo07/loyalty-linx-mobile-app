import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:loyaltylinx/pages/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({
    super.key,
  });

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

var _sendVia = 'Email';
var apiParams = 'email';
String? userId;
String? secretCode;

const apiFogotPasw = "https://loyaltylinx.cyclic.app/api/user/find-account";
const apiValidate = "https://loyaltylinx.cyclic.app/api/user/validate-code";
const apiUrlUpdatePass =
    "https://loyaltylinx.cyclic.app/api/user/change-password";

final _recoveryController = TextEditingController();

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

class _ForgetPasswordState extends State<ForgetPassword> {
  Future findAccount(String recoveryAccount, context) async {
    showDialog(
        barrierColor: Theme.of(context).colorScheme.background,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    final response = await http.post(
      Uri.parse(apiFogotPasw),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({apiParams: recoveryAccount}),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint(json);
      setState(() {
        userId = json['userId'];
        secretCode = json['secretCode'];
      });
      Navigator.push(
          context,
          routeTransition(OtpForgetPass(
            secretCode: secretCode.toString(),
            userId: userId.toString(),
          )));
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessage(title: "Failed to fint account", message: message);
    }
  }

  final _formKey = GlobalKey<FormState>();
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
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const Row(
              children: [
                Text(
                  "Choose recovery email",
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
                    _recoveryController.clear();
                    _sendVia = "Email";
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
                    _recoveryController.clear();
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
            createAccInput(
                context, (p0) => null, _sendVia == "Email" ? 200 : 11, (value) {
              if (value == null || value.isEmpty) {
                return "Please input valid email";
              }
            }, _sendVia == "Email" ? "Email" : "Mobile No", _recoveryController,
                _sendVia == "Email" ? TextInputType.text : TextInputType.phone),
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
                  if (_formKey.currentState!.validate()) {
                    findAccount(_recoveryController.text.toString(), context);
                  }
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

TextFormField createAccInput(
  BuildContext context,
  Function(String) onChange,
  numLength,
  Function validator,
  hintText,
  controller,
  TextInputType keyboardType,
) {
  return TextFormField(
    keyboardType: keyboardType,
    inputFormatters: [LengthLimitingTextInputFormatter(numLength)],
    onChanged: (value) {
      onChange(value);
    },
    onTapOutside: (event) {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    controller: controller,
    validator: (value) => validator(value),
    decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 16),
        errorStyle: const TextStyle(fontSize: 10),
        errorBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: .5, color: Theme.of(context).colorScheme.primary)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: Colors.amber.shade700),
        )),
  );
}

class OtpForgetPass extends StatefulWidget {
  final String secretCode;
  final String userId;
  const OtpForgetPass(
      {super.key, required this.secretCode, required this.userId});

  @override
  State<OtpForgetPass> createState() => _OtpForgetPassState();
}

class _OtpForgetPassState extends State<OtpForgetPass> {
  Future validate(String code, context) async {
    showDialog(
        barrierColor: Theme.of(context).colorScheme.background,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    final response = await http.post(
      Uri.parse(apiValidate),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"userId": widget.userId, "secretCode": code}),
    );
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          routeTransition(NewPasswordForm(
            userId: widget.userId,
          )));
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      await showMessage(
          title: "Failed to find account", message: "Invalid code");
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text('We sent code via to',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500)),
                Text(_sendVia,
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
                    // showDialog(
                    //     barrierColor: Theme.of(context).colorScheme.background,
                    //     barrierDismissible: false,
                    //     context: context,
                    //     builder: (context) {
                    //       return const Center(
                    //           child: CircularProgressIndicator());
                    //     });
                    validate(value, context);
                    setState(() {
                      // clear = true;
                    });

                    // login(widget.email, widget.passWord, value, context);
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
                    debugPrint(widget.secretCode);
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
                const SizedBox(height: 30)
              ],
            ),
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
}

final _newPasswordController = TextEditingController();
final _newConfirmController = TextEditingController();

class NewPasswordForm extends StatefulWidget {
  final String userId;
  const NewPasswordForm({super.key, required this.userId});

  @override
  State<NewPasswordForm> createState() => NewPasswordFormState();
}

Future<void> deleteUserData(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  Future.delayed(const Duration(seconds: 5));
  Navigator.of(context).pushAndRemoveUntil(
      routeTransition(const LoginPage()), (Route<dynamic> route) => false);
}

bool _obscureText = true;
bool _obscureTextConfirm = true;

class NewPasswordFormState extends State<NewPasswordForm> {
  Future<void> updatePass(newPassword, confirmPassword, context) async {
    showDialog(
        barrierColor: Theme.of(context).colorScheme.background,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    var url = Uri.parse(apiUrlUpdatePass);
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': widget.userId,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword
        }));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessageSuccess(title: "Sucess", message: message);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessage(title: "Failed to change password", message: message);
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Row(children: [
                Text('New Password'),
              ]),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _newPasswordController,
                onChanged: (pass) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$')
                      .hasMatch(value)) {
                    return 'Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, and one digit';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Password not match';
                  }
                  if (value.length < 8) {
                    return 'Please enter a password with at least 8 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    errorMaxLines: 2,
                    errorStyle: const TextStyle(fontSize: 10),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: .5,
                            color: Theme.of(context).colorScheme.primary)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1.5, color: Colors.amber.shade700),
                    )),
                textInputAction: TextInputAction.done,
                obscureText: _obscureText,
              ),
              const SizedBox(
                height: 16,
              ),
              const Row(children: [
                Text('Confirm New Password'),
              ]),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _newConfirmController,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value != _newConfirmController.text) {
                    return 'Password not match';
                  }
                  if (value.length < 8) {
                    return 'Please enter a password with at least 8 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextConfirm = !_obscureTextConfirm;
                        });
                      },
                    ),
                    errorStyle: const TextStyle(fontSize: 10),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: .5,
                            color: Theme.of(context).colorScheme.primary)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1.5, color: Colors.amber.shade700),
                    )),
                textInputAction: TextInputAction.done,
                obscureText: _obscureTextConfirm,
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
                    if (_formKey.currentState!.validate()) {
                      updatePass(_newPasswordController.text.toString(),
                          _newConfirmController.text.toString(), context);
                    }
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
              const SizedBox(height: 20)
            ],
          ),
        ),
      )),
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

  showMessageSuccess({required String title, required String message}) {
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
                  showDialog(
                      barrierColor: Theme.of(context).colorScheme.background,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      });
                  deleteUserData(context);
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
