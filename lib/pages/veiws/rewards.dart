import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyaltylinx/pages/veiws/reward_transaction.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Add ytiour body content here.
    return const RewardView();
  }
}

final List<Map<String, Object>> mechants = [
  {"path": "assets/images/amazon.png"},
  {"path": "assets/images/sm.png"},
  {"path": "assets/images/mcdo.png"},
  {"path": "assets/images/jollibee.png"},
  {"path": "assets/images/walmart.png"},
  {"path": "assets/images/super8.jpg"},
];

const number = 2000.24;

class RewardView extends StatelessWidget {
  const RewardView({super.key});

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

class MyBodyWidget extends StatelessWidget {
  const MyBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDark = brightness == Brightness.dark;
    SizedBox buttons(onPress, pathLight, title, pathDark) {
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
                  child: isDark
                      ? Image.asset(
                          pathLight,
                          fit: BoxFit.scaleDown,
                        )
                      : Image.asset(pathDark, fit: BoxFit.scaleDown),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            )),
      );
    }

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 248, 204, 129),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width / 1,
            child: Column(
              children: [
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
                        child: const Center(
                          child: Text(
                            " $number",
                            style: TextStyle(
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
                      "Available points",
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

      Container(
        margin: const EdgeInsets.fromLTRB(20, 2, 20, 2),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey.shade500))),
        child: Row(
          children: [
            const Text(
              "History",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/transactions_reward');
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: const Text(
                "see all",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8.0),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width / 1,
        height: MediaQuery.of(context).size.width / 0.7,
        child: ListView.builder(
            itemCount: _loans.length,
            itemBuilder: (BuildContext context, int index) {
              final merch = staticTransactData[index]['merhcant'];
              final action = staticTransactData[index]['action'];
              final date = staticTransactData[index]['date'];
              final amount = staticTransactData[index]['amount'];
              final status = staticTransactData[index]['status'];
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
                                  status == 'add'
                                      ? CupertinoIcons.add
                                      : CupertinoIcons.minus,
                                  size: 12,
                                  color: status == 'add'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                Text("$amount",
                                    style: TextStyle(
                                        color: status == 'add'
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
      // Padding(
      //     padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      //     child: GridView.builder(
      //       shrinkWrap: true,
      //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //         crossAxisCount: 3,
      //         mainAxisSpacing: 16.0,
      //         crossAxisSpacing: 16.0,
      //       ),
      //       physics: const ClampingScrollPhysics(),
      //       itemCount: mechants.length,
      //       itemBuilder: (BuildContext context, int index) {
      //         final path = mechants[index]["path"];
      //         return merchant(context, path, () {});
      //       },
      //     )),
      const SizedBox(height: 30.0),
    ]));
  }

  InkWell merchant(BuildContext context, path, onTap) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        width: MediaQuery.of(context).size.width * .16,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
                image: AssetImage(path), fit: BoxFit.scaleDown)),
      ),
    );
  }
}
