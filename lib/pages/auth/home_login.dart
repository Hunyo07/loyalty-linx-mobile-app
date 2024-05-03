// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyaltylinx/pages/auth/register.dart';
import 'dart:async';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

AppBar buildAppBar(context) {
  return AppBar(
    title: SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Image.asset("assets/images/loyaltilinxicon.png"),
    ),
    centerTitle: true,
    leading: null,
    automaticallyImplyLeading: false,
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.background,
    toolbarHeight: MediaQuery.of(context).size.height / 14,
  );
}

final _allViews = <Widget>[
  ImageBox(
      buttonText: "Become a merchant partner!",
      path: "assets/images/blackman.png",
      endorse:
          "Join us as a merchant partner and embark on a journey of growth and success together!",
      onTap: () {},
      btnColor: Colors.blue.shade400),
  ImageBox(
      buttonText: "Register your business",
      path: "assets/images/whiteman.png",
      endorse:
          "Join us on a journey of growth and opportunity as we guide you through the process, ensuring your venture is recognized and protected!",
      onTap: () {},
      btnColor: Colors.green.shade400),
  ImageBox(
      buttonText: "Register as individual",
      path: "assets/images/women.png",
      endorse:
          "Embark on an enriching journey as a individual with our esteemed partnership!",
      onTap: (context) {
        _registerView(context);
      },
      btnColor: Colors.orange.shade400),
];

int _pageIndicator = 0;
final _duplicatedAllViews = [..._allViews.reversed, ..._allViews];

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _bodyhome(context),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  SafeArea _bodyhome(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "All in one Credit",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Stack(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height * .7,
              child: PageView.builder(
                itemCount: _duplicatedAllViews.length * 10000,
                controller: PageController(initialPage: 5001, keepPage: true),
                itemBuilder: (context, index) {
                  return _duplicatedAllViews[index % _allViews.length];
                },
                onPageChanged: (value) {
                  setState(() {
                    _pageIndicator = value % _allViews.length;
                  });
                },
              ),
            ),
            Positioned(
                bottom: 10,
                right: 0,
                left: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                        _allViews.length,
                        (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: _pageIndicator == index ? 18 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.amber.shade900,
                                border: Border.all(
                                    color: Colors.amber.shade900, width: 2),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            )))))
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.width / 5,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade900,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)))),
                      child: const FittedBox(
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ))),
            ],
          ),
        ],
      ),
    );
  }
}

Future<dynamic> _registerView(BuildContext context) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 1,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return const RegisterView();
            });
      });
}

class ImageBox extends StatelessWidget {
  final String buttonText;
  final String path;
  final String endorse;
  final Function onTap;
  final Color btnColor;

  const ImageBox({
    super.key,
    required this.buttonText,
    required this.path,
    required this.endorse,
    required this.onTap,
    required this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Theme.of(context).colorScheme.primaryContainer),
              child: Image.asset(
                path,
                fit: BoxFit.fitHeight,
              )),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width / 9,
            child: ElevatedButton(
                onPressed: () {
                  onTap(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                )),
          ),
          Center(
              child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(22),
                  child: Text(
                    endorse,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ))
            ],
          )),
        ],
      ),
    );
  }
}
