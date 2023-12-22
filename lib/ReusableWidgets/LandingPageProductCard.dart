import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class LandingPageProductCard extends StatelessWidget {
  final String product_id;
  final String productName;
  final String productPrice;
  final String brandLogo;
  final String productImageUrl;
  final VoidCallback onTap;

  const LandingPageProductCard({
    super.key,
    required this.product_id,
    required this.productName,
    required this.productPrice,
    required this.brandLogo,
    required this.productImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        height: 350,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              productImageUrl,
              width: 150,
              height: 150,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTextWidget(productName),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    brandLogo,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTextWidget('EGP' + productPrice),
                Row(
                  children: [
                    buildIconButton(Icons.shopping_cart_outlined),
                    buildIconButton(Icons.favorite_border)
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

Widget buildTextWidget(String text) {
  return Expanded(
    child: Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontFamily: 'Cairo-Medium', fontSize: 20),
    ),
  );
}



Widget buildIconButton(IconData icon) {
  return IconButton(
    onPressed: () {},
    icon: Icon(
      icon,
      color: Color(0xFFFFFFFF),
      size: 24,
    ),
  );
}
