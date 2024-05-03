// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';

String user = "John paul";
const CurrencyFormat phpSettings = CurrencyFormat(
  code: 'php',
  symbol: 'Php',
  symbolSide: SymbolSide.left,
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

    return MyBodyWidget();
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

class MyBodyWidget extends StatelessWidget {
  MyBodyWidget({
    super.key,
  });

  final isVerified = userData1[0]['verification']['isVerified'];

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cardPoints(context, balance, "Available Credits", "Credits", () {
                Navigator.pushNamed(context, '/transactions_credit');
              }, "Transactions"),
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
                "Points history",
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 5.5,
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 65,
                            crossAxisSpacing: 20),
                    clipBehavior: Clip.none,
                    children: [
                      buttons(
                          'assets/images/web_browser.png',
                          'assets/images/apply_light.png',
                          isVerified != false
                              ? () {
                                  print(userData1[0]['verification']
                                      ['isVerified']);
                                }
                              : null,
                          "Apply credit"),
                      buttons(
                          'assets/images/payment.png',
                          'assets/images/payment_method_light.png',
                          () {},
                          "Pay loan"),
                      buttons(
                          'assets/images/monitor.png',
                          'assets/images/monitor_light.png',
                          () {},
                          "Status monitor"),
                      buttons(
                        'assets/icons/conversion-rate.png',
                        'assets/icons/conversionLight.png',
                        () {},
                        "Conversion",
                      ),
                      buttons(
                        'assets/icons/gift.png',
                        'assets/icons/giftLight.png',
                        () {},
                        "Redeem",
                      ),
                      buttons(
                        'assets/icons/noun-loan.png',
                        'assets/icons/noun-loanLight.png',
                        () {},
                        "Loan",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const Row(
            children: [
              Text(
                "Whats new?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
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
              height: MediaQuery.of(context).size.height / 3.4,
              child: PageView.builder(
                  controller: PageController(
                    viewportFraction: .80,
                    initialPage: 1,
                    keepPage: true,
                  ),
                  itemCount: _promotions.length,
                  itemBuilder: (context, index) {
                    return _promotions[index];
                  }),
            )
          ]),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Spendings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "see all",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade600),
                ),
              )
            ],
          ),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.width / seeAll,
            child: ListView.builder(
                itemCount: _spendings.length,
                itemBuilder: (BuildContext context, int index) {
                  final action = _spendings[index]['action'];
                  final date = _spendings[index]['date'];
                  final amount = _spendings[index]['amount'];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
                    child: InkWell(
                      splashColor: Colors.grey,
                      splashFactory: InkRipple.splashFactory,
                      onTap: () {
                        // _showTransactionDetailsDialog(
                        //     context, merch, action, date, amount);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: MediaQuery.of(context).size.height * .10,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 1,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 1),
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 40,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                          ' $action',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        )),
                                    Container(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                          ' $date',
                                          style: const TextStyle(),
                                        )),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Icon(
                                      _spendings[index]['status'] == 'add'
                                          ? CupertinoIcons.add
                                          : CupertinoIcons.minus,
                                      size: 12,
                                      color:
                                          _spendings[index]['status'] == 'add'
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    Text("$amount",
                                        style: TextStyle(
                                            color: _spendings[index]
                                                        ['status'] ==
                                                    'add'
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // .addOnLongPress(() => _deleteTransaction(context, index));
                  );
                }),
          )
        ]),
      ),
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
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Image.asset(
                        'assets/images/loyaltilinxicon.png',
                        fit: BoxFit.scaleDown,
                      )),
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
                            Icons.history,
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
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Ink(
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
                          child: Text(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade900,
                                fontSize: 18),
                          ),
                        )
                      ]),
                ),
              ),
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
              onPressed: () {},
              child: const Text(
                "Apply now",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
