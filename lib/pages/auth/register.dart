import 'package:flutter/material.dart';
import 'package:loyaltylinx/pages/auth/create_acc_number.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Image.network(
                      "https://cdn-icons-png.freepik.com/512/2133/2133123.png")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade900,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  onPressed: null,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Link your Reward Card!',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              const SizedBox(height: 16.0),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                            BorderSide(color: Colors.amber.shade900, width: 2)),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NumberRegister()));
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Create account with Mobile Number',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              const SizedBox(height: 22.0),
              const Text(
                "or",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8.0),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                    ),
                    onPressed: () {},
                    child: SizedBox(
                        height: 32,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Image.network(
                                  "http://pngimg.com/uploads/google/google_PNG19635.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Continue with Google",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ]))),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField registerForm(laberlText, iconPref, colorIcon, hintText) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: laberlText,
        labelStyle: const TextStyle(
          fontSize: 16,
        ),
        enabledBorder:
            UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
        prefixIcon: iconPref,
        prefixIconColor: colorIcon,
        fillColor: Colors.white,
        filled: true,
        focusedBorder:
            UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
      ),
      // controller: _bdateController,
    );
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

  AppBar buildAppBar() {
    return AppBar(
      title: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: Image.asset(
          'assets/images/loyaltilinxicon.png',
          fit: BoxFit.scaleDown,
        ),
      ),
      centerTitle: true,
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
}

PageRouteBuilder<dynamic> routeTransition(screenView) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 200),
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
