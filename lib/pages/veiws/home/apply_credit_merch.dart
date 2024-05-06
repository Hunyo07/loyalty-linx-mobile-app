import 'package:flutter/material.dart';

class ApplyCredit extends StatefulWidget {
  final List<Map<String, dynamic>> merchants;
  const ApplyCredit({super.key, required this.merchants});

  @override
  State<ApplyCredit> createState() => _ApplyCreditState();
}

final List<Map<String, Object>> mechantser = [
  {"path": "assets/images/amazon.png"},
  {"path": "assets/images/sm.png"},
  {"path": "assets/images/mcdo.png"},
];

class _ApplyCreditState extends State<ApplyCredit> {
  void refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Merchants",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: SafeArea(
          child: RefreshIndicator(
              onRefresh: () async {
                return refreshList();
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                      ),
                      physics: const ClampingScrollPhysics(),
                      itemCount: widget.merchants.length,
                      itemBuilder: (BuildContext context, int index) {
                        final path = widget.merchants[index]["profilePicture"];
                        final storeName = widget.merchants[index]['storeName'];
                        return Column(
                          children: [merchant(context, path, () {}, storeName)],
                        );
                      },
                    )),
              )
              // CustomScrollView(
              //   physics: const BouncingScrollPhysics(),
              //   slivers: [
              //     SliverList(
              //         delegate: SliverChildListDelegate([
              //       Row(children: [
              //         Container(
              //             padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              //             child: const Text("Available merchants",
              //                 style: TextStyle(
              //                     fontSize: 18, fontWeight: FontWeight.w600))),
              //       ]),
              //     ])),
              //     SliverList.builder(
              //         itemCount: widget.merchants.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           final path = widget.merchants[index]["profilePicture"];
              //           final action = widget.merchants[index]['storeName'];
              //           // final date = staticTransactData[index]['date'];

              //           return Container(
              //             padding: const EdgeInsets.all(5),
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(8.0)),
              //             child: InkWell(
              //               splashFactory: InkRipple.splashFactory,
              //               borderRadius: BorderRadius.circular(10),
              //               onTap: () {
              //                 // _showTransactionDetailsDialog(
              //                 //     context, merch, action, date, amount);
              //               },
              //               child: Ink(
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                   color: Theme.of(context)
              //                       .colorScheme
              //                       .primaryContainer,
              //                 ),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: <Widget>[
              //                     Container(
              //                       padding: const EdgeInsets.all(10),
              //                       height: MediaQuery.of(context).size.height *
              //                           .10,
              //                       child: Row(
              //                         children: [
              //                           Container(
              //                             width: MediaQuery.of(context)
              //                                     .size
              //                                     .width *
              //                                 .25,
              //                             decoration: BoxDecoration(
              //                                 borderRadius:
              //                                     BorderRadius.circular(10),
              //                                 image: DecorationImage(
              //                                     image: NetworkImage(path),
              //                                     fit: BoxFit.contain)),
              //                           ),
              //                           Column(
              //                             mainAxisAlignment:
              //                                 MainAxisAlignment.center,
              //                             crossAxisAlignment:
              //                                 CrossAxisAlignment.start,
              //                             children: [
              //                               Container(
              //                                   padding:
              //                                       const EdgeInsets.all(3),
              //                                   child: Text(
              //                                     ' $action',
              //                                     style: const TextStyle(
              //                                         fontWeight:
              //                                             FontWeight.w600,
              //                                         fontSize: 18),
              //                                   )),
              //                               Container(
              //                                   padding:
              //                                       const EdgeInsets.all(3),
              //                                   child: const Text(
              //                                     ' 100 peso = 1 point',
              //                                     style:
              //                                         TextStyle(fontSize: 12),
              //                                   )),
              //                             ],
              //                           ),
              //                           const Spacer(),
              //                         ],
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           );
              //         }),

              //   ],
              // ),
              ),
        ));
  }

  InkWell merchant(BuildContext context, path, onTap, name) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Column(
        children: [
          Ink(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .16,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                    image: NetworkImage(path), fit: BoxFit.cover)),
            child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )),
          ),
          const Text(
            ' 100 peso = 1 point',
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  void showTransactionDetailsDialog(
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
}
