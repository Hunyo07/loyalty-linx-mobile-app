import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreditPage extends StatelessWidget {
  const CreditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Add ytiour body content here.
    return const MyBodyWidget();
  }
}

const CurrencyFormat phpSettings = CurrencyFormat(
  code: 'php',
  symbol: 'Php',
  symbolSide: SymbolSide.left,
  thousandSeparator: ',',
  decimalSeparator: '.',
  symbolSeparator: ' ',
);
final List<Map<String, Object>> _loans = [
  {
    "description": "FOr the family",
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

final List<Map<String, Object>> mechants = [
  {"merch": "Loans", "path": "assets/images/blackman.png"},
  {"merch": "Offers", "path": "assets/images/women.png"},
  {"merch": "Hotel", "path": "assets/images/whiteman.png"},
  {"merch": "Shop", "path": "assets/images/women.png"},
  {"merch": "invite", "path": "assets/images/whiteman.png"},
  {"merch": "List", "path": "assets/images/women.png"},
  {"merch": "Time", "path": "assets/images/blackman.png"},
  {"merch": "Images", "path": "assets/images/whiteman.png"},
  {"merch": "Friends", "path": "assets/images/women.png"},
  {"merch": "Exact", "path": "assets/images/blackman.png"},
  {"merch": "Secret", "path": "assets/images/whiteman.png"},
  {"merch": "Favorites", "path": "assets/images/blackman.png"}
];

const number = 2000.24;

String amountDue = CurrencyFormatter.format(number, phpSettings);

class MyBodyWidget extends StatelessWidget {
  const MyBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDark = brightness == Brightness.dark;
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 248, 204, 129),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            height: MediaQuery.of(context).size.height / 6.5,
            width: MediaQuery.of(context).size.width / 1,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Due Date",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            "5/2/2024",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade500,
                            ),
                          ),
                        ],
                      ),
                    ]),
                FittedBox(
                  child: Center(
                    child: Text(
                      "Amount Due",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  child: Container(
                      // height: MediaQuery.of(context).size.height * .04,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.zero,
                              topRight: Radius.zero,
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5))),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        child: Center(
                          child: Text(
                            amountDue,
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 150, 70, 9)),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buttons(isDark, 'assets/images/web_browser.png',
              'assets/images/apply_light.png', () {}, "Apply"),
          buttons(isDark, 'assets/images/payment.png',
              'assets/images/payment_method_light.png', () {}, "Pay"),
          buttons(isDark, 'assets/images/monitor.png',
              'assets/images/monitor_light.png', () {}, "Status"),
          buttons(
            isDark,
            'assets/icons/history.png',
            'assets/icons/historyLight.png',
            () {
              Navigator.pushNamed(context, '/transactions_credit');
            },
            "History",
          ),
        ],
      ),
      const SizedBox(height: 16.0),
      Container(
        margin: const EdgeInsets.fromLTRB(20, 2, 20, 2),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey.shade500))),
        child: const Row(
          children: [
            Text(
              "Loans",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8.0),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.width / 0.9,
        child: ListView.builder(
            itemCount: _loans.length,
            itemBuilder: (BuildContext context, int index) {
              final action = _loans[index]['action'];
              final date = _loans[index]['date'];
              final amount = _loans[index]['amount'];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
                child: InkWell(
                  splashColor: Colors.grey,
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
                          color: Theme.of(context).colorScheme.primaryContainer,
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
                                  _loans[index]['status'] == 'add'
                                      ? CupertinoIcons.add
                                      : CupertinoIcons.minus,
                                  size: 12,
                                  color: _loans[index]['status'] == 'add'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                Text("$amount",
                                    style: TextStyle(
                                        color: _loans[index]['status'] == 'add'
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
      ),
    ]));
  }

  SizedBox buttons(bool isDark, pathLight, pathDark, onPress, title) {
    return SizedBox(
      width: 64,
      child: InkWell(
          onTap: () {
            onPress();
          },
          child: Column(
            children: [
              SizedBox(
                width: 35,
                height: 35,
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

  InkWell merchant(BuildContext context, path, text, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width * .16,
          decoration: BoxDecoration(
              color: Colors.amber.shade900,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  image: AssetImage(path), fit: BoxFit.scaleDown)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FittedBox(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  decoration: const BoxDecoration(color: Colors.black26),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
