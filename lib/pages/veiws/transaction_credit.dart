// ignore_for_file: avoid_print
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:currency_formatter/currency_formatter.dart';

String user = "John paul";

const CurrencyFormat euroSettings = CurrencyFormat(
  code: 'php',
  symbol: 'Php',
  symbolSide: SymbolSide.left,
  thousandSeparator: ',',
  decimalSeparator: '.',
  symbolSeparator: ' ',
);

Map values = {
  "a": "Elephant",
  "b": "Horse",
  "c": "Lion",
  "d": "Deer",
  "e": "Bear",
  "f": "Moi",
  "g": "aSD"
};

final List<Map<String, Object>> staticTransactData = [
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

final List<String> animals = <String>[...values.values];

num amount = 1910.9347;
num amountDue = 200.93;

class Transaction extends StatelessWidget {
  const Transaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: transactAppBar(context),
      body: _buildBody(),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  Widget _buildBody() {
    // Add ytiour body content here.

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          // const TransactBody(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  Row(children: [
                    Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: const Text("History",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))),
                  ]),
                ])),
                SliverList.builder(
                    itemCount: staticTransactData.length,
                    itemBuilder: (BuildContext context, int index) {
                      final merch = staticTransactData[index]['merhcant'];
                      final action = staticTransactData[index]['action'];
                      final date = staticTransactData[index]['date'];
                      final amount = staticTransactData[index]['amount'];

                      String formattedDue =
                          CurrencyFormatter.format(amount, euroSettings);

                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0)),
                        child: InkWell(
                          onTap: () => _showTransactionDetailsDialog(
                              context, merch, action, date, amount),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(5),
                                height:
                                    MediaQuery.of(context).size.height * .10,
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
                                      size: 50,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            )),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        FittedBox(
                                          child: Icon(
                                            staticTransactData[index]
                                                        ['status'] ==
                                                    'add'
                                                ? CupertinoIcons.add
                                                : CupertinoIcons.minus,
                                            color: staticTransactData[index]
                                                        ['status'] ==
                                                    'add'
                                                ? Colors.green
                                                : Colors.red,
                                            size: 12,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Text(formattedDue,
                                              style: TextStyle(
                                                  color:
                                                      staticTransactData[index]
                                                                  ['status'] ==
                                                              'add'
                                                          ? Colors.green
                                                          : Colors.red.shade600,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12)),
                                        ),
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
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showTransactionDetailsDialog(
    BuildContext context, merch, action, date, amount) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(merch),
              Text(action),
              Text("amount : $amount"),
              Text("Date : " "$date"),
            ],
          ),
        ),
      );
    },
  );
}

InkWell merchant(BuildContext context, path, text, onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: MediaQuery.of(context).size.height * .09,
      decoration: BoxDecoration(
          color: Colors.amber.shade900,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          image:
              DecorationImage(image: AssetImage(path), fit: BoxFit.scaleDown)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FittedBox(
              child: Container(
            width: MediaQuery.of(context).size.width * .20,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
        ],
      ),
    ),
  );
}

class TransactBody extends StatelessWidget {
  const TransactBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
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
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                      // color: Colors.white,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: FittedBox(
                                    child: Container(
                                      margin: const EdgeInsets.all(3),
                                      child: const Center(
                                        child: Text(
                                          "Credit amount due",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 150, 70, 9)),
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3)),
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(3),
                                        child: Center(
                                          child: Text(
                                            "$amountDue",
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    255, 150, 70, 9)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .31,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 1, 4, 1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2)),
                                  child: const Text(
                                    "Due date",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 73, 31, 0),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 1, 4, 1),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Text(
                                    "4/3/2024",
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber.shade900,
                                    padding: const EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2))),
                                child: const Text("Pay credit",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ))),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber.shade900,
                                    padding: const EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2))),
                                child: const Text("Apply credit",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ))),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber.shade900,
                                    padding: const EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(2))),
                                child: const Text("Loan status",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      )),
    );
  }
}

AppBar transactAppBar(context) {
  return AppBar(
    title: FittedBox(
      child: Text(
        'Transaction history',
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600),
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    elevation: 0,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

class ButtonBack extends StatelessWidget {
  const ButtonBack({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(0, 255, 214, 64),
          elevation: 0,
          padding: const EdgeInsets.all(2)),
      child: Center(
          child: Icon(
        Icons.arrow_back,
        color: Colors.amber.shade800,
      )),
    );
  }
}
