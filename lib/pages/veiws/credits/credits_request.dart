import 'package:flutter/material.dart';

class CreditRequests extends StatefulWidget {
  final List<Map<String, dynamic>> creditRequests;
  const CreditRequests({super.key, required this.creditRequests});

  @override
  State<CreditRequests> createState() => _CreditRequestsState();
}

class _CreditRequestsState extends State<CreditRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              Row(children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: const Text("Credits Requests",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600))),
              ]),
            ])),
            SliverList.builder(
                itemCount: widget.creditRequests.length,
                itemBuilder: (BuildContext context, int index) {
                  final store = widget.creditRequests[index]['merchantName'];
                  final status = widget.creditRequests[index]['status'];
                  final amount = widget.creditRequests[index]['creditAmount'];
                  final date = widget.creditRequests[index]['applicationDate']
                      .toString()
                      .substring(0, 10);
                  return Container(
                    padding: const EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              height: MediaQuery.of(context).size.height * .10,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Store',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    ' $store',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Amount',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    '${amount.toString()}.00 Peso',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16),
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15),
                                              ),
                                              Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    '$status..',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Text(
                                      date,
                                      style: const TextStyle(fontSize: 12),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class EmptyCrediRequests extends StatefulWidget {
  const EmptyCrediRequests({super.key});

  @override
  State<EmptyCrediRequests> createState() => _EmptyCrediRequestsState();
}

class _EmptyCrediRequestsState extends State<EmptyCrediRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: const Column(
        children: [
          Center(
            child: Text("No Data"),
          )
        ],
      ),
    );
  }
}
