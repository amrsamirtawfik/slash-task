import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLandingPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomLandingPageAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF191919),
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      title: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Slash.',
          style: TextStyle(
            fontFamily: 'Cairo-Black',
            fontSize: 50.0,
          ),
        ),
      ),
    );
  }
}
class CustomProductDetailsPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomProductDetailsPageAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF191919),
      toolbarHeight: 80,

      title: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Product details',
          style: TextStyle(
            fontFamily: 'Cairo-Black',
            fontSize: 50.0,
          ),
        ),
      ),
    );
  }
}
