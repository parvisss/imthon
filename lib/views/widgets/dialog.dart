import 'package:flutter/material.dart';

class Dialog extends StatelessWidget {
  const Dialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Text("Add event"),
    );
  }
}
