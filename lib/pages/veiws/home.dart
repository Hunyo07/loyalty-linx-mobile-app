// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:loyaltylinx/main.dart';
import 'package:loyaltylinx/pages/veiws/home/apply_credit_merch.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:loyaltylinx/pages/veiws/verification/otp_send_method.dart';
import 'package:http/http.dart' as http;
import 'package:unicons/unicons.dart';

const CurrencyFormat phpSettings = CurrencyFormat(
  code: 'php',
  symbol: 'Php',
  symbolSide: SymbolSide.none,
  thousandSeparator: ',',
  decimalSeparator: '.',
  symbolSeparator: ' ',
);

final formatter = NumberFormat.currency(
  locale: 'fil',
  symbol: 'PHP',
);

final _promotions = <Widget>[
  Merchant(
    model: "assets/images/women.png",
    title: "Book Your Flight Now!",
    path: "assets/images/airplane.jpg",
    onTap: () {
      print("this q");
    },
  ),
  Merchant(
    model: "assets/images/blackman.png",
    title: "Shop  Owner",
    path: "assets/images/bgOrange.jpg",
    onTap: () {
      print("this q");
    },
  ),
  Merchant(
    path: "assets/images/colorful.jpg",
    title: "Shop  Owner",
    model: "assets/images/whiteman.png",
    onTap: () {
      print("this q");
    },
  ),
];
final _deals = <Widget>[
  Deals(
    model: "assets/images/women.png",
    title: "Book Your Flight Now!",
    path: "assets/images/airplane.jpg",
    onTap: () {
      print("this q");
    },
  ),
  Deals(
    model: "assets/images/blackman.png",
    title: "Shop  Owner",
    path: "assets/images/bgOrange.jpg",
    onTap: () {
      print("this q");
    },
  ),
  Deals(
    path: "assets/images/colorful.jpg",
    title: "Shop  Owner",
    model: "assets/images/whiteman.png",
    onTap: () {
      print("this q");
    },
  ),
];

const balancecredit = 20000.24;
String balance = CurrencyFormatter.format(balancecredit, phpSettings);
const pointsBal = 200.20;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  Widget _buildBody() {
    // Add ytiour body content here.

    return const MyBodyWidget();
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        var planets = {
          "first": "earth",
          "second": "mars",
          "third": "jupiter",
          "fourth": "saturn",
          2: "sando"
        };
        planets[1] = "uranus";
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(0, 255, 214, 64),
        elevation: 0,
      ),
      child: Column(
        children: [Container()],
      ),
    );
  }
}

int _pageIndicator = 1;
int _dealIndicator = 1;

final List<Map<String, Object>> _spendings = [
  {
    "merhcant": "Loan",
    "action": "Paid",
    "date": "3 April 2024, 856 PM",
    "amount": 1500.23,
    "status": "less"
  },
  {
    "merhcant": "Shop",
    "action": "Buy",
    "date": "5 April 2024, 856 PM",
    "amount": 1502.23,
    "status": "less"
  },
  {
    "merhcant": "Hotel",
    "action": "Paid",
    "date": "3 April 2022, 856 PM",
    "amount": 6000.23,
    "status": "less"
  },
  {
    "merhcant": "Travel",
    "action": "Paid",
    "date": "3 April 2024, 856 PM",
    "amount": 150.23,
    "status": "less"
  },
  {
    "merhcant": "Travel",
    "action": "Hotel",
    "date": "3 April 2024, 856 PM",
    "amount": 510.23,
    "status": "less"
  },
  {
    "merhcant": "Gift",
    "action": "Receive",
    "date": "3 April 2024, 856 PM",
    "amount": 510.23,
    "status": "add"
  },
  {
    "merhcant": "Hotel",
    "action": "Paid",
    "date": "3 April 2024, 856 PM",
    "amount": 510.23,
    "status": "less"
  },
  {
    "merhcant": "Hotel",
    "action": "Rent",
    "date": "3 April 2024, 856 PM",
    "amount": 510.23,
    "status": "add"
  },
  {
    "merhcant": "Gift",
    "action": "Recieve",
    "date": "3 April 2024, 856 PM",
    "amount": 510.23,
    "status": "add"
  },
];

double seeAll = 1.5;

class MyBodyWidget extends StatefulWidget {
  const MyBodyWidget({
    super.key,
  });

  @override
  State<MyBodyWidget> createState() => _MyBodyWidgetState();
}

bool? isVerified;
String? statusHome;
String? code;

class _MyBodyWidgetState extends State<MyBodyWidget> {
  @override
  void initState() {
    print(userData1[0]['verification']['isVerified']);
    isVerified = userData1[0]['verification']['isVerified'];
    statusHome = userData1[0]['verification']['status'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> getMerchantsList(context) async {
      showDialog(
          barrierColor: Theme.of(context).colorScheme.background,
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      var url =
          Uri.parse('https://loyalty-linxapi.vercel.app/api/merchant/get-all');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenMain',
        },
      );
      if (response.statusCode == 200) {
        final json = (jsonDecode(response.body)['merchants'] as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).push(
          routeTransition(ApplyCredit(merchants: json)),
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop();

        print("faield");
      }
    }

    Future<void> refreshCode(
        String apiRefreshCode, String token, context) async {
      var url = Uri.parse(apiRefreshCode);
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        code = json['secretCode'];

        Navigator.pushReplacement(context,
            routeTransition(ApplyCreditOtp(userCode: json['secretCode']!)));
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        final json = jsonDecode(response.body);
        print(json);
      }
    }

    Future<void> handleToSendOtp() async {
      Navigator.pop(context);
      showDialog(
          barrierColor: Theme.of(context).colorScheme.background,
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      refreshCode('https://loyalty-linxapi.vercel.app/api/user/refresh-code',
          tokenMain!, context);
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
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("Yes"),
                  onPressed: () async {
                    handleToSendOtp();
                    // refreshCode(
                    //     'https://loyalty-linxapi.vercel.app/api/user/refresh-code',
                    //     tokenMain!,
                    //     context);
                    // Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }

    showMessagePending({required String title, required String message}) {
      showCupertinoDialog(
          context: context,
          builder: (contex) {
            return CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }

    Brightness brightness = Theme.of(context).brightness;
    bool isDark = brightness == Brightness.dark;

    SizedBox buttons(pathLight, pathDark, onPress, title) {
      return SizedBox(
        width: 64,
        child: ElevatedButton(
            onPressed: onPress,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(vertical: 5),
                elevation: 0,
                backgroundColor: Colors.transparent),
            child: Column(
              children: [
                SizedBox(
                  width: 40,
                  child: !isDark
                      ? Image.asset(
                          pathLight,
                          fit: BoxFit.scaleDown,
                        )
                      : Image.asset(pathDark, fit: BoxFit.scaleDown),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 10),
                )
              ],
            )),
      );
    }

    return SingleChildScrollView(
      child: Column(children: <Widget>[
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cardPoints(context, balance, "Available Credits", "Credits", () {
              Navigator.pushNamed(context, '/transactions_credit');
            }, "History"),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cardPoints(
              context,
              pointsBal,
              "Available Points",
              "Rewards",
              () {
                Navigator.pushNamed(context, '/transactions_reward');
              },
              "History",
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 15),
                    child: Text(
                      "Services",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 5.5,
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 65,
                      crossAxisSpacing: 20),
                  clipBehavior: Clip.none,
                  children: [
                    buttons(
                        'assets/images/web_browser.png',
                        'assets/images/apply_light.png',
                        statusHome == "new" && isVerified! == false
                            ? () {
                                showMessage(
                                    title: 'Not verified yet',
                                    message:
                                        'You want to proceed to veirification?');
                              }
                            : statusHome == "pending" && isVerified! == false
                                ? () {
                                    showMessagePending(
                                        message:
                                            "Your verification request is still on process",
                                        title: "");
                                  }
                                : statusHome == "approved" &&
                                        isVerified! == true
                                    ? () async {
                                        getMerchantsList(context);
                                      }
                                    : () {
                                        showMessage(
                                            title: 'Not verified yet',
                                            message:
                                                'You want to proceed to veirification?');
                                      },
                        "Apply credit"),
                    buttons('assets/images/payment.png',
                        'assets/images/payment_method_light.png', () {
                      print(userData1);
                    }, "Pay credit"),
                    buttons(
                        'assets/icons/conversion-rate.png',
                        'assets/icons/conversionLight.png',
                        () {},
                        "Convert points"),
                    buttons(
                      'assets/icons/gift.png',
                      'assets/icons/giftLight.png',
                      () {},
                      "Redeem",
                    ),
                    buttons(
                      'assets/images/monitor.png',
                      'assets/images/monitor_light.png',
                      () {},
                      "Discover deals",
                    ),
                    buttons(
                      'assets/icons/more.png',
                      'assets/icons/more_light.png',
                      () {},
                      "More",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Whats new?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                children: [
                  AutoSizeText(
                    'Experience and enjoy our exciting updates',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: 16.0),
        Stack(children: [
          // Text("hodtog"),
          Container(
            padding: const EdgeInsets.all(2),
            width: MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.height / 3.2,
            child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _pageIndicator = index % _promotions.length;
                  });
                },
                controller: PageController(
                  viewportFraction: .80,
                  initialPage: 1,
                  keepPage: true,
                ),
                itemCount: _promotions.length,
                itemBuilder: (context, index) {
                  return _promotions[index];
                }),
          ),
        ]),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List<Widget>.generate(
                  _promotions.length,
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
                      )))),
        ),
        const SizedBox(height: 16.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Deals and more.....",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: 16.0),
        Stack(children: [
          // Text("hodtog"),
          Container(
            padding: const EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.height / 3.2,
            child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _dealIndicator = index % _deals.length;
                  });
                },
                controller: PageController(
                  viewportFraction: .80,
                  initialPage: 1,
                  keepPage: true,
                ),
                itemCount: _deals.length,
                itemBuilder: (context, index) {
                  return _deals[index];
                }),
          ),
        ]),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: List<Widget>.generate(
                  _promotions.length,
                  (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: _dealIndicator == index ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade900,
                          border: Border.all(
                              color: Colors.amber.shade900, width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      )))),
        ),
        const SizedBox(height: 30.0),
      ]),
    );
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

  Container cardPoints(
      BuildContext context, balance, labelBal, cardLabel, ontap, onTapLabel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 215, 177, 113),
              Color.fromARGB(255, 255, 162, 100)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      height: MediaQuery.of(context).size.height / 7,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(3)),
                  child: FittedBox(
                    child: Text(
                      "$balance",
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 150, 70, 9)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                FittedBox(
                  child: Center(
                    child: Text(
                      labelBal,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 15),
                  //     child: Image.asset(
                  //       'assets/images/loyaltilinxicon.png',
                  //       fit: BoxFit.scaleDown,
                  //     )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 28,
                        child: Image.asset('assets/images/splash.png'),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Sample App",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.amber.shade900,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      onPressed: ontap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            UniconsLine.history,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 3.0),
                          Text(
                            onTapLabel,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class Merchant extends StatelessWidget {
  const Merchant(
      {super.key,
      required this.path,
      required this.title,
      required this.model,
      required this.onTap});
  final String path;
  final String title;
  final String model;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(path))),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(model))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                      )
                    ]),
              ),
            ),
          ),
          const Text(
            "Title",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const Text(
            "Descriptions",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.amber.shade900),
            onPressed: () {
              onTap();
            },
            child: const Text(
              "Trip for more details",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class Deals extends StatelessWidget {
  const Deals(
      {super.key,
      required this.path,
      required this.title,
      required this.model,
      required this.onTap});
  final String path;
  final String title;
  final String model;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(path))),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(model))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                      )
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
