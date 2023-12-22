import 'package:flutter/material.dart';

import '../Bloc/DataStructures.dart';
import '../Bloc/ProductsBloc.dart';
import 'ImageSlider.dart';
import 'ProductDescriptionDropDown.dart';
import 'ProductInfoViewer.dart';
import 'ProductOptionsNavigator.dart';

class ProductDetailsWidget extends StatefulWidget {
  final Product product; // Replace with the actual state class

  ProductDetailsWidget({required this.product});

  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ImageSlider(images: widget.product.productDetailsObject!.images),
        ProductInfoViewer(
          name: widget.product.name,
          price: convertToString(widget.product.productDetailsObject?.price),
          brandLogo: widget.product.productDetailsObject!.brandLogoUrl,
          brandName: widget.product.productDetailsObject!.brandName,
        ),
        ProductsOptionsNavigator(
          navigationObject:
              widget.product.productDetailsObject!.navigationObject,
          currentVariationId: widget.product.productDetailsObject!.variation_id,
          product_id: widget.product.id,
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ProductDescriptionDropDown(
            description: widget.product.productDetailsObject!.description,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
                onPressed:
                    widget.product.productDetailsObject!.in_stock ? (){} : null,
                child: Text(
                  'Add to cart',
                  style: TextStyle(fontFamily: 'Cairo-Medium', fontSize: 20),
                )))
      ],
    );
  }
}
