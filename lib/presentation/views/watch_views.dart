import 'package:flutter/material.dart';

class WatchScreen extends StatelessWidget {
  static const name = 'WatchScreen';
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Hola WatchScreen'),
      ),
    );
  }
}
