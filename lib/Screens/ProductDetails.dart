import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slash_task/ReusableWidgets/ImageSlider.dart';
import 'package:slash_task/Bloc/ProductsBloc.dart';
import 'package:slash_task/ReusableWidgets/CustomAppBar.dart';
import 'package:slash_task/ReusableWidgets/ProductDescriptionDropDown.dart';
import 'package:slash_task/ReusableWidgets/ProductInfoViewer.dart';
import 'package:slash_task/ReusableWidgets/ProductOptionsNavigator.dart';

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
              return Column(
                children: [
                  ImageSlider(
                      images: state.product.productDetailsObject!.images),
                  ProductInfoViewer(
                      name: state.product.name,
                      price: convertToString(
                          state.product.productDetailsObject?.price),
                      brandLogo:
                          state.product.productDetailsObject!.brandLogoUrl,
                      brandName: state.product.productDetailsObject!.brandName),
                  // ProductsOptionsNavigator(options: options),
                  Text('Product name: ${state.product.name}'),
                  ProductDescriptionDropDown(
                      description:
                          state.product.productDetailsObject!.description)
                ],
              );
            } else if (state is ProductsError) {
              return CustomErrorWidget(errMsg: state.errorMessage);
            }

            // Return a default widget if the state is not recognized
            return Text('m7slsh 7aga ya alb akhook');
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
