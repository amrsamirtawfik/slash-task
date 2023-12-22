import 'package:flutter/material.dart';

class ProductDescriptionDropDown extends StatefulWidget {
  final String description;

  const ProductDescriptionDropDown({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  _ProductDescriptionDropDownState createState() =>
      _ProductDescriptionDropDownState();
}

class _ProductDescriptionDropDownState
    extends State<ProductDescriptionDropDown> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            children: [
              Text(
                'Description',
                style: TextStyle(fontSize: 20, fontFamily: 'CairoMedium'),
              ),
              Icon(
                isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.description,
              style: TextStyle(fontSize: 20, fontFamily: 'CairoMedium'),
            ),
          ),
      ],
    );
  }
}
