// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PhoneNumber extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var number;

  PhoneNumber({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              Divider(
                height: 2,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const Text('Confirmed')
            ]),
      ),
    );
  }
}
