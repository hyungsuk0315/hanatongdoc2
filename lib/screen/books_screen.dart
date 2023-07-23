import 'package:flutter/material.dart';
import '../widget/show_book.dart';
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
          body: const Column(
            children: [
              ShowBook(),
            ],
          ),
          ),
        );
  }
}
