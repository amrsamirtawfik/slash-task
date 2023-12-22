import 'package:flutter/cupertino.dart';

class CustomGrid extends StatelessWidget {
  final List<Widget> children;

  CustomGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (children.length / 2).ceil(),
      itemBuilder: (BuildContext context, int index) {
        int startIndex = index * 2;
        int endIndex = startIndex + 1;

        // Ensure endIndex is within the bounds of the list
        endIndex = endIndex < children.length ? endIndex : children.length - 1;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: children[startIndex],
            ),
            SizedBox(width: 8),
            endIndex != startIndex //because if their number is odd last row will be duplicated
                ? Expanded(child: children[endIndex])
                : Spacer(),
          ],
        );
      },
    );
  }
}
