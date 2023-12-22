import 'package:flutter/material.dart';

class ProductInfoViewer extends StatelessWidget {
  final String name;
  final String price;
  final String brandLogo;
  final String brandName;

  const ProductInfoViewer({
    Key? key,
    required this.name,
    required this.price,
    required this.brandLogo,
    required this.brandName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'EGP $price',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.network(
                brandLogo,
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8.0),
              Text(
                brandName,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
