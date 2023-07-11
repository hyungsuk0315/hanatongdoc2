import 'package:flutter/material.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
          appBar:AppBar(
              title: Text('하나 통독'),
              leading: ImageIcon(
                  AssetImage('images/lalab_logo.png')
              ),
          ),
          bottomNavigationBar: Material(
            child:TabBar( tabs: [
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  'Tab1',
                ),
              ),
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  'Tab2',
                ),
              ),
            ],

            )
          ),
        )
    );
  }
}
