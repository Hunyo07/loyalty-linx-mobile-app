import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Email extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var email;
  Email({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              email,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            Divider(
              height: 2,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const Text("Email")
          ],
        ),
      ),
    );
  }
}
