import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:loyaltylinx/main.dart';
import 'package:loyaltylinx/pages/veiws/credits/credits_request.dart';
import 'package:loyaltylinx/pages/veiws/home.dart';

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
  symbolSide: SymbolSide.none,
  thousandSeparator: ',',
  decimalSeparator: '.',
  symbolSeparator: ' ',
);
final List<Map<String, Object>> mechants = [
  {"path": "assets/images/amazon.png"},
  {"path": "assets/images/sm.png"},
  {"path": "assets/images/mcdo.png"},
  {"path": "assets/images/jollibee.png"},
  {"path": "assets/images/walmart.png"},
  {"path": "assets/images/super8.jpg"},
];

const number = 20000.24;

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
                FittedBox(
                  child: Center(
                    child: Text(
                      "Available credits",
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
              'assets/images/monitor_light.png', () {
            if (isVerified == true) {
              final credits = userData0![0]['creditRequests']!;
              if (credits.isNotEmpty) {
                final creditRequestsList = (credits as List)
                    .map((dynamic e) => e as Map<String, dynamic>)
                    .toList();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreditRequests(
                            creditRequests: creditRequestsList)));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EmptyCrediRequests()));
              }
            } else {}
          }, "Request"),
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
              "Merchants",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8.0),
      // Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 15),
      //   width: MediaQuery.of(context).size.width / 1,
      //   height: MediaQuery.of(context).size.width / 0.9,
      //   child: ListView.builder(
      //       itemCount: _loans.length,
      //       itemBuilder: (BuildContext context, int index) {
      //         final action = _loans[index]['action'];
      //         final date = _loans[index]['date'];
      //         final amount = _loans[index]['amount'];
      //         return Container(
      //           padding: const EdgeInsets.symmetric(vertical: 5),
      //           decoration:
      //               BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
      //           child: InkWell(
      //             splashColor: Colors.grey,
      //             onTap: () {
      //               // _showTransactionDetailsDialog(
      //               //     context, merch, action, date, amount);
      //             },
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: <Widget>[
      //                 Container(
      //                   padding: const EdgeInsets.all(5),
      //                   height: MediaQuery.of(context).size.height * .10,
      //                   decoration: BoxDecoration(
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Colors.black.withOpacity(0.1),
      //                         blurRadius: 1,
      //                         spreadRadius: 2,
      //                         offset: const Offset(0, 1),
      //                       )
      //                     ],
      //                     borderRadius: BorderRadius.circular(10),
      //                     color: Theme.of(context).colorScheme.primaryContainer,
      //                   ),
      //                   child: Row(
      //                     children: [
      //                       const Icon(
      //                         Icons.shopping_bag_outlined,
      //                         size: 40,
      //                       ),
      //                       Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Container(
      //                               padding: const EdgeInsets.all(3),
      //                               child: Text(
      //                                 ' $action',
      //                                 style: const TextStyle(
      //                                     fontWeight: FontWeight.w600,
      //                                     fontSize: 18),
      //                               )),
      //                           Container(
      //                               padding: const EdgeInsets.all(3),
      //                               child: Text(
      //                                 ' $date',
      //                                 style: const TextStyle(),
      //                               )),
      //                         ],
      //                       ),
      //                       const Spacer(),
      //                       Row(
      //                         children: [
      //                           Icon(
      //                             _loans[index]['status'] == 'add'
      //                                 ? CupertinoIcons.add
      //                                 : CupertinoIcons.minus,
      //                             size: 12,
      //                             color: _loans[index]['status'] == 'add'
      //                                 ? Colors.green
      //                                 : Colors.red,
      //                           ),
      //                           Text("$amount",
      //                               style: TextStyle(
      //                                   color: _loans[index]['status'] == 'add'
      //                                       ? Colors.green
      //                                       : Colors.red,
      //                                   fontWeight: FontWeight.bold,
      //                                   fontSize: 12)),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //           // .addOnLongPress(() => _deleteTransaction(context, index));
      //         );
      //       }),
      // ),
      Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            physics: const ClampingScrollPhysics(),
            itemCount: mechants.length,
            itemBuilder: (BuildContext context, int index) {
              final path = mechants[index]["path"];
              return merchant(context, path, () {});
            },
          )),
    ]));
  }

  SizedBox buttons(bool isDark, pathLight, pathDark, onPress, title) {
    return SizedBox(
      width: 64,
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
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

  InkWell merchant(BuildContext context, path, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width * .16,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  image: AssetImage(path), fit: BoxFit.scaleDown)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [],
          )),
    );
  }
}
