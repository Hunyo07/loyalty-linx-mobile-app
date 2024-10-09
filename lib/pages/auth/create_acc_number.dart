// ignore_for_file: unused_local_variable, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loyaltylinx/pages/auth/login.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';

final _emailController = TextEditingController();
final _firstNameController = TextEditingController();
final _lastNameController = TextEditingController();
final _passwordController = TextEditingController();
final _passwordConfirmController = TextEditingController();
final _middleController = TextEditingController();
final _mobileNumberController = TextEditingController();
final _monthController = TextEditingController();
final _dayController = TextEditingController();
final _yearController = TextEditingController();

String code = "";
var countryCode = '';
String? helperText = "Please input valid mobile number";

class NumberRegister extends StatefulWidget {
  const NumberRegister({super.key});

  @override
  State<NumberRegister> createState() => _NumberRegisterState();
}

String formattedMonth = DateFormat('MM').format(DateTime.now());

bool _obscureText = true;
bool _obscureTextConfirm = true;
bool _isCheck = true;
const apiUrlRegister = 'https://loyalty-linxapi.vercel.app/api/user/register';
const apiUrls = 'https://loyalty-linxapi.vercel.app/api/user/login';
const apiUrlProfile = 'https://loyalty-linxapi.vercel.app/api/user/profile';
const apiUrlValidate =
    'https://loyalty-linxapi.vercel.app/api/user/validate-code-login';
String? pattern;
RegExp? regExp;

class _NumberRegisterState extends State<NumberRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    pattern = r'^[0-8]\d{9}$';
    regExp = RegExp(pattern!);
    super.initState();
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
        'mobileNo': '0${_mobileNumberController.text.toString()}',
        'birthdate':
            "${_monthController.text}-${_dayController.text}-${_yearController.text}",
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _emailController.clear();
      _passwordController.clear();
      _passwordConfirmController.clear();
      _firstNameController.clear();
      _lastNameController.clear();
      _middleController.clear();
      _mobileNumberController.clear();
      _dayController.clear();
      _monthController.clear();
      _yearController.clear();
      showMessageSccess(
          title: "Success!", message: "You registered successfully!");
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessage(title: "Failed to register", message: message);
    }
  }

  // PhoneNumber number = PhoneNumber(isoCode: 'PH');
  bool validatePhoneNumber(String value) {
    String pattern = r'^\+?[\d\s()-]*$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool? phoneNumber = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
            child: SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              onChanged: () {},
              child: Column(
                children: [
                  const SizedBox(
                    height: 22,
                  ),
                  title("Mobile Number"),
                  IntlPhoneField(
                    disableAutoFillHints: true,
                    autovalidateMode: AutovalidateMode.disabled,
                    controller: _mobileNumberController,
                    showCountryFlag: false,
                    decoration: InputDecoration(
                      helperMaxLines: 2,
                      helperText: phoneNumber == false ? helperText! : null,
                      helperStyle: TextStyle(
                          fontSize: 10,
                          color: phoneNumber == false
                              ? const Color.fromARGB(255, 255, 121, 111)
                              : Theme.of(context).colorScheme.primary),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2,
                            color: phoneNumber == false
                                ? Colors.red
                                : Colors.amber.shade700),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: phoneNumber != false
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : Colors.red,
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primaryContainer,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                        ),
                      ),
                    ),
                    initialCountryCode: 'PH',
                    onChanged: (value) {
                      if (value.number.length == 10) {
                        phoneNumber = true;
                      } else {
                        phoneNumber = false;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  title("Email"),
                  createAccInput(
                    context,
                    (value) {},
                    200,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return "Please input valid email";
                      }
                    },
                    "Enter you email address",
                    _emailController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  title("First Name"),
                  createAccInput(
                    context,
                    (value) {},
                    20,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return "Please fill up";
                      }
                      return null;
                    },
                    "Enter your first name",
                    _firstNameController,
                  ),
                  const SizedBox(height: 16.0),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Column(
                              children: [
                                title("Last Name"),
                                createAccInput(
                                  context,
                                  (value) {},
                                  20,
                                  (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please fill up";
                                    }
                                    return null;
                                  },
                                  "Enter your last name",
                                  _lastNameController,
                                ),
                              ],
                            )),
                        const SizedBox(width: 12.0),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: Column(
                              children: [
                                title("M.I"),
                                createAccInput(
                                  context,
                                  (value) {},
                                  1,
                                  (value) {
                                    return null;
                                  },
                                  "",
                                  _middleController,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  title("Password"),
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
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                          .hasMatch(value)) {
                        return 'Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one digit and one special character';
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
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.primaryContainer,
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
                                width: 1,
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Colors.amber.shade700),
                        )),
                    textInputAction: TextInputAction.done,
                    obscureText: _obscureText,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  title("Confirm password"),
                  TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
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
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        errorStyle: const TextStyle(fontSize: 10),
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Colors.amber.shade700),
                        )),
                    textInputAction: TextInputAction.done,
                    obscureText: _obscureTextConfirm,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                          value: _isCheck,
                          onChanged: (value) {
                            setState(() {
                              _isCheck = value!;
                            });
                          }),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Text.rich(
                          maxLines: 3,
                          TextSpan(
                              text: "I have read and accept Sample App ",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                    text: "Terms and Conditions ",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.amber.shade900,
                                        decorationThickness: 2,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber.shade900)),
                                const TextSpan(text: "and "),
                                TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.amber.shade900,
                                        decorationThickness: 2,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber.shade900)),
                              ]),
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
                      onPressed: () {
                        //
                        if (_formKey.currentState!.validate() &&
                            _isCheck != false &&
                            _mobileNumberController.text.isNotEmpty &&
                            !regExp!.hasMatch(
                                _mobileNumberController.text.toString())) {
                          register(context);
                        } else {
                          setState(() {
                            phoneNumber = false;
                          });
                          if (_mobileNumberController.text.isEmpty) {
                            setState(() {
                              helperText = "Please input valid mobile number";
                            });
                          } else if (regExp!.hasMatch(
                              _mobileNumberController.text.toString())) {
                            setState(() {
                              helperText =
                                  'Please input valid mobile number that starts with number 9';
                            });
                          } else
                            (setState(() {
                              phoneNumber = true;
                            }));
                        }
                      },
                      child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "SUBMIT",
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

  Column title(String title) {
    return Column(children: [
      Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(
        height: 8.0,
      )
    ]);
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
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: controller,
      validator: (value) => validator(value),
      decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.primaryContainer,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 12),
          errorStyle: const TextStyle(fontSize: 10),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: Theme.of(context).colorScheme.secondary)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.amber.shade700),
          )),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("",
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

  showMessageSccess({required String title, required String message}) {
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
                  Navigator.pushAndRemoveUntil(
                      context,
                      routeTransition(LoginPage(
                        mobileNo: "0${_mobileNumberController.text.toString()}",
                      )),
                      (route) => false);
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
