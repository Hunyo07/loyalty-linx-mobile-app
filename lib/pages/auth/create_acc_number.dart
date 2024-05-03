// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:loyaltylinx/pages/auth/verfication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

final _emailController = TextEditingController();
final _firstNameController = TextEditingController();
final _lastNameController = TextEditingController();
final _passwordController = TextEditingController();
final _passwordConfirmController = TextEditingController();
final _middleController = TextEditingController();

final _monthController = TextEditingController();
final _dayController = TextEditingController();
final _yearController = TextEditingController();

String code = "";
var countryCode = '';
String? phoneNumber;

class NumberRegister extends StatefulWidget {
  const NumberRegister({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NumberRegisterState createState() => _NumberRegisterState();
}

String formattedMonth = DateFormat('MM').format(DateTime.now());

bool _obscureText = true;
bool _obscureTextConfirm = true;
const apiUrlRegister = 'https://loyaltylinx.cyclic.app/api/user/register';
const apiUrls = 'https://loyaltylinx.cyclic.app/api/user/login';
const apiUrlProfile = 'https://loyaltylinx.cyclic.app/api/user/profile';
const apiUrlValidate =
    'https://loyaltylinx.cyclic.app/api/user/validate-code-login';

class _NumberRegisterState extends State<NumberRegister> {
  final _formKey = GlobalKey<FormState>();

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
  }

  Future<void> saveUserToken(Map<String, dynamic> userToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', jsonEncode(userToken));
  }

  Future register(context) async {
    showDialog(
        barrierColor: Theme.of(context).colorScheme.background,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    final response = await http.post(
      Uri.parse(apiUrlRegister),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text.toString(),
        'password': _passwordController.text.toString(),
        'firstName': _firstNameController.text.toString(),
        'middleName': _middleController.text.toString(),
        'lastName': _lastNameController.text.toString(),
        'mobileNo': phoneNumber,
        'birthdate':
            "${_monthController.text}-${_dayController.text}-${_yearController.text}",
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      Navigator.of(context).pushAndRemoveUntil(
          routeTransition(Verification(
            apiUrlValidate: apiUrlValidate,
            apiUrlLogin: apiUrls,
            passWord: _passwordConfirmController.text,
            email: _emailController.text,
            mobileNo: "$phoneNumber",
          )),
          (route) => false);
      _emailController.clear();
      _passwordController.clear();
      _passwordConfirmController.clear();
      _firstNameController.clear();
      _lastNameController.clear();
      _middleController.clear();
      phoneNumber = '';
      _dayController.clear();
      _monthController.clear();
      _yearController.clear();
    } else {
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessage(title: "Failed to register", message: message);
    }
  }

  PhoneNumber number = PhoneNumber(isoCode: 'PH');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
            child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              onChanged: () {},
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/loyaltilinxicon.png',
                    fit: BoxFit.scaleDown,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: const Text("First Name"),
                        ),
                        const SizedBox(width: 12.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: const Text("Last Name"),
                        ),
                        const SizedBox(width: 12.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: const Text("M.I"),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: createAccInput(
                              context,
                              (value) {},
                              20,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please fill up";
                                }
                                return null;
                              },
                              "",
                              _firstNameController,
                            )),
                        const SizedBox(width: 12.0),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: createAccInput(
                              context,
                              (value) {},
                              20,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please fill up";
                                }
                                return null;
                              },
                              "",
                              _lastNameController,
                            )),
                        const SizedBox(width: 12.0),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: createAccInput(
                              context,
                              (value) {},
                              1,
                              (value) {
                                return null;
                              },
                              "Optional",
                              _middleController,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Row(
                    children: [Text("Birthdate")],
                  ),
                  const SizedBox(height: 16.0),
                  const Row(children: [
                    Text('Mobile Number'),
                  ]),
                  const SizedBox(
                    height: 16,
                  ),
                  InternationalPhoneNumberInput(
                    onInputValidated: (bool value) {},
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    onInputChanged: (PhoneNumber number) {
                      // print(number.phoneNumber);
                      phoneNumber = number.phoneNumber;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: const OutlineInputBorder(),
                    onSaved: (PhoneNumber number) {},
                    ignoreBlank: false,
                    maxLength: 11,
                    formatInput: true,
                    initialValue: number,
                    spaceBetweenSelectorAndTextField: 1,
                    autoValidateMode: AutovalidateMode.disabled,
                    inputDecoration: InputDecoration(
                        errorStyle: const TextStyle(fontSize: 10),
                        errorMaxLines: 2,
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: .5,
                                color: Theme.of(context).colorScheme.primary)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5, color: Colors.amber.shade700),
                        )),
                  ),
                  const Row(children: [
                    Text('Email'),
                  ]),
                  const SizedBox(
                    height: 16,
                  ),
                  createAccInput(
                    context,
                    (value) {},
                    200,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return "Please input valid email";
                      }
                    },
                    "",
                    _emailController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(children: [
                    Text('Password'),
                  ]),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    onChanged: (pass) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (!RegExp(
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$')
                          .hasMatch(value)) {
                        return 'Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, and one digit';
                      }
                      if (value != _passwordConfirmController.text) {
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
                          borderSide: BorderSide(
                              width: 1.5, color: Colors.amber.shade700),
                        )),
                    textInputAction: TextInputAction.done,
                    obscureText: _obscureText,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(children: [
                    Text('Confirm password'),
                  ]),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordConfirmController,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value != _passwordController.text) {
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
                          borderSide: BorderSide(
                              width: 1.5, color: Colors.amber.shade700),
                        )),
                    textInputAction: TextInputAction.done,
                    obscureText: _obscureTextConfirm,
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          register(context);
                        }
                      },
                      child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Sign me up",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ))),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        )));
  }

  TextFormField createAccInput(
    BuildContext context,
    Function(String) onChange,
    numLength,
    Function validator,
    hintText,
    controller,
  ) {
    return TextFormField(
      inputFormatters: [LengthLimitingTextInputFormatter(numLength)],
      onChanged: (value) {
        onChange(value);
      },
      controller: controller,
      validator: (value) => validator(value),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 10),
          errorStyle: const TextStyle(fontSize: 10),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: .5, color: Theme.of(context).colorScheme.primary)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.amber.shade700),
          )),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Register",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => {Navigator.pop(context)},
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "LOGIN",
                style: TextStyle(fontSize: 16),
              ),
            ))
      ],
      elevation: 0,
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
