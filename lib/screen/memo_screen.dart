import 'package:flutter/material.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar:AppBar(
            title: Text('하나 통독'),
            leading: ImageIcon(
                AssetImage('images/lalab_logo.png')
            )
        ),
      )
    );
  }
}
