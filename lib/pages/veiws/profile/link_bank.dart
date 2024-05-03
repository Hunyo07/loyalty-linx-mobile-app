import 'package:flutter/material.dart';

class  LinkBank extends StatelessWidget {
  const LinkBank({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: const Column(
            children: [],
          ),
        ));
  }
}
