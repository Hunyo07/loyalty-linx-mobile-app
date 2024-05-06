// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loyaltylinx/main.dart';
import 'package:loyaltylinx/pages/auth/forget_password.dart';
import 'package:loyaltylinx/pages/auth/otp_verification.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String? mobileNo;
  const LoginPage({super.key, this.mobileNo});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

bool _obscureText = true;

const apiUrlLogin = 'https://loyaltylinx.cyclic.app/api/user/login';
const apiUrlProfile = 'https://loyaltylinx.cyclic.app/api/user/profile';
const apiUrlValidate =
    'https://loyaltylinx.cyclic.app/api/user/validate-code-login';

@override
class _LoginPageState extends State<LoginPage> {
  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pushNamed(context, '/homeView');
        },
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
        ),
      ),
    );
  }

  String errorMessage = "";
  String? code;
  bool onLoad = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Future<void> saveUserData(Map<String, dynamic> objectToken) async {
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
        userData0 = [userData];
        tokenMain = objectToken['token'];
        saveUserData(objectToken);
        Navigator.of(context).pushAndRemoveUntil(
            routeTransition(BottomNavBarExample(userData: [userData])),
            (Route<dynamic> route) => false);
      } else {
        final json = jsonDecode(response.body);
        final message = json['message'];
        print(json);
        await showMessage(title: "Failed to login", message: message);
      }
    }

    Future login(String username, String password, context) async {
      showDialog(
          barrierColor: Theme.of(context).colorScheme.background,
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      onLoad = true;
      final response = await http.post(
        Uri.parse(apiUrlLogin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'email': username, 'password': password, 'role': "user"}),
      );
      if (response.statusCode == 200) {
        final jsonToken = jsonDecode(response.body);
        final token = jsonToken['token'];
        final isFirtTimeLogin = jsonToken['isFirstTimeLogin'];
        if (isFirtTimeLogin != true) {
          getProfile(token, jsonToken, context);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              routeTransition(OtpVerification(
                  token: jsonToken,
                  sendMethod: "Mobile No",
                  apiUrlValidate: apiUrlValidate)),
              (Route<dynamic> route) => false);
        }
      } else {
        // final json = jsonDecode(response.body);
        print(response.body);
        // final message = json['message'];
        // await showMessage(title: "Failed to login", message: message);
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 7,
                    child: Image.asset('assets/images/loyaltilinxicon.png'),
                  ),
                  const SizedBox(height: 5.0),
                  const Row(children: [
                    // Text(
                    //   "Mobile Number",
                    //   style: TextStyle(
                    //       color: Theme.of(context).colorScheme.primary),
                    // ),
                  ]),
                  // IntlPhoneField
                  TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                    onChanged: (phoneNumber) {},
                    decoration: InputDecoration(
                        labelText: "Email",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: .5,
                                color: Theme.of(context).colorScheme.primary)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5, color: Colors.amber.shade700),
                        )),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: _passwordController,
                    onChanged: (pass) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Please enter a password with at least 8 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        labelText: "Password",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: .5,
                                color: Theme.of(context).colorScheme.primary)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5, color: Colors.amber.shade700),
                        )),
                    textInputAction: TextInputAction.done,
                    obscureText: _obscureText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ForgetPassword()));
                        },
                        child: const Text(
                          "FORGOT PASSWORD",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade900,
                      padding: const EdgeInsets.all(14.0),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      elevation: 5,
                    ),
                    onPressed:
                        // onLoad == true
                        //     ? null
                        //     :

                        () async {
                      if (_formKey.currentState!.validate()) {
                        login(_emailController.text.toString(),
                            _passwordController.text.toString(), context);
                      } else {
                        setState(() {
                          onLoad == false;
                        });
                      }
                    },
                    child: const SizedBox(
                      height: 30,
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    _obscureText = true;
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  TextStyle Styles() {
    return TextStyle(fontSize: 18, color: Colors.amber.shade800);
  }

  BorderRadius inputBorderRadius() {
    return const BorderRadius.only(
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
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
                  setState(() {
                    onLoad = true;
                  });
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
      return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ));
    },
  );
}
