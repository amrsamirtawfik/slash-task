import 'package:flutter/cupertino.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errMsg;

  CustomErrorWidget({required this.errMsg});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          errMsg,
          style: const TextStyle(fontFamily: 'Cairo-Bold', fontSize: 40),
        ),
      ),
    ));
  }
}
