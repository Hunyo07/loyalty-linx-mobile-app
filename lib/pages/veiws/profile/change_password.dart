import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loyaltylinx/pages/veiws/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

// PageRouteBuilder<dynamic> routeTransition(screenView) {
//   return PageRouteBuilder(
//     transitionDuration: const Duration(milliseconds: 300),
//     pageBuilder: (context, animation, secondaryAnimation) => screenView,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return SlideTransition(
//         position: Tween<Offset>(
//           begin: const Offset(1, 0),
//           end: Offset.zero,
//         ).animate(animation),
//         child: child,
//       );
//     },
//   );
// }

class NewPasswordForm extends StatefulWidget {
  const NewPasswordForm({super.key});

  @override
  State<NewPasswordForm> createState() => NewPasswordFormState();
}

String? token;
String? userId;
bool _obscureText = true;
bool _obscureTextConfirm = true;
bool _obscureTextCurrents = true;
final _newPasswordController = TextEditingController();
final _newConfirmController = TextEditingController();
final _currentPasswordController = TextEditingController();
final apiUrlChangePass =
    'https://loyalty-linxapi.vercel.app/api/user/update-password/$userId';

class NewPasswordFormState extends State<NewPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  void getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokens = prefs.getString('user_token');

    if (tokens != null) {
      final tokenJson = jsonDecode(tokens);
      setState(() {
        token = (tokenJson)['token'].toString();
        userId = (tokenJson)['userId'].toString();
      });
    } else {
      debugPrint('User data not found');
    }
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
  }

  Future<void> changePass(password, newPassword, context) async {
    showDialog(
        barrierColor: Theme.of(context).colorScheme.background,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    var url = Uri.parse(apiUrlChangePass);
    var response = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
            {"currentPassword": password, "newPassword": newPassword}));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
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
                Text('Current Password'),
              ]),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _currentPasswordController,
                onChanged: (pass) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current password';
                  }
                  if (value != _currentPasswordController.text) {
                    return 'Password not match';
                  }

                  return null;
                },
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                    helperMaxLines: 2,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextCurrents
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextCurrents = !_obscureTextCurrents;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                    errorStyle: const TextStyle(fontSize: 10),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.secondary)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.amber.shade700),
                    )),
                textInputAction: TextInputAction.done,
                obscureText: _obscureTextCurrents,
              ),
              const SizedBox(
                height: 16,
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
                  if (!RegExp(
                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
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
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
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
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                    errorStyle: const TextStyle(fontSize: 10),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.secondary)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.amber.shade700),
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
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
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
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                    errorStyle: const TextStyle(fontSize: 10),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.secondary)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.amber.shade700),
                    )),
                textInputAction: TextInputAction.done,
                obscureText: _obscureTextConfirm,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade900,
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            changePass(
                                _currentPasswordController.text.toString(),
                                _newPasswordController.text.toString(),
                                context);
                          }
                        },
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      )),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _newConfirmController.clear();
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
