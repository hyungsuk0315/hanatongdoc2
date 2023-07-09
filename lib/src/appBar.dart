import 'package:flutter/material.dart';

class LalabAppBar extends StatelessWidget {
  const LalabAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AppBar(
        title: Text('하나 통독'),
        leading: ImageIcon(
            AssetImage('images/lalab_logo.png')
        ),
      ),
    );
  }
}
