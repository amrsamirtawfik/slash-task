import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slash_task/ReusableWidgets/ImageSlider.dart';
import 'package:slash_task/Bloc/ProductsBloc.dart';
import 'package:slash_task/ReusableWidgets/CustomAppBar.dart';
import 'package:slash_task/ReusableWidgets/ProductDescriptionDropDown.dart';
import 'package:slash_task/ReusableWidgets/ProductDetailsWidget.dart';
import 'package:slash_task/ReusableWidgets/ProductInfoViewer.dart';
import 'package:slash_task/ReusableWidgets/ProductOptionsNavigator.dart';
import 'package:slash_task/Screens/LandingPage.dart';

import '../Bloc/DataStructures.dart';
import '../Bloc/States.dart';
import '../ReusableWidgets/ErrorWidget.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product detials'),
        ),
        body: BlocConsumer<ProductsBloc, ProductsState>(
          listener: (context, state) {},
          builder: (context, state) {
            print(state);
            // Builder is used to rebuild the UI based on the current state
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OpenedProductFetched) {
              print('found product: ${state.product}');
              return ProductDetailsWidget(product: state.product);
            } else if (state is VariationChanged) {
              return ProductDetailsWidget(product: state.product);
            } else if (state is ProductsError) {
              return CustomErrorWidget(errMsg: state.errorMessage);
            }

            // Return a default widget if the state is not recognized
            return Text('Default');
          },
        ));
  }
}

/*
* Column(
        children: [
          ImageSlider(images: imageUrls),
          ProductInfoViewer(
              name: product.name,
              price:convertToString( product.productDetailsObject?.price),
              brandLogo: product.productDetailsObject!.brandLogoUrl,
              brandName: product.productDetailsObject!.brandName),
         // ProductsOptionsNavigator(options: options),
          Text('Product name: ${product.name}'),
          ProductDescriptionDropDown(
              description: product.productDetailsObject!.description)
        ],
      )
* */
