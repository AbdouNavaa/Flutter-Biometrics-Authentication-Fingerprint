import 'package:flutter/material.dart';

class PrivatePage extends StatelessWidget {
  const PrivatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Private")),

      body: Center(child: Text("Private Content Here!")),
    );
  }
}
