import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slash_task/Bloc/DataStructures.dart';
import 'package:slash_task/Bloc/ProductsBloc.dart';
import 'package:slash_task/Bloc/States.dart';
import 'package:slash_task/ReusableWidgets/CustomAppBar.dart';
import 'package:slash_task/ReusableWidgets/CustomGrid.dart';

import '../ReusableWidgets/ErrorWidget.dart';
import '../ReusableWidgets/LandingPageProductCard.dart';
import 'ProductDetails.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductsBloc.get(context)
        .fetch_parse_main_products(); //fetch data when app opens
    return Scaffold(
        appBar: CustomLandingPageAppBar(),
        body: BlocConsumer<ProductsBloc, ProductsState>(
            listener: (context, state) {},
            builder: (context, state) {
              // print(state);
              if (state is ProductsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MainProductsLoaded) {
                printLongString(state.products.length.toString());
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomGrid(
                    children: state.products
                        .map((product) => LandingPageProductCard(
                              product_id: product.id,
                              productName: product.name,
                              productPrice: convertToString(product.mainPrice),
                              brandLogo: product.brandLogoUrl,
                              productImageUrl: product.mainImage,
                              onTap: () {
                                ProductsBloc.get(context)
                                    .fetch_opened_product(product.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductDetails()),
                                );
                              },
                            ))
                        .toList(),
                  ),
                );
              } else if (state is ProductsError) {
                return CustomErrorWidget(errMsg: state.errorMessage);
              }

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomGrid(
                  children: ProductsBloc.get(context)
                      .products
                      .map((product) => LandingPageProductCard(
                            product_id: product.id,
                            productName: product.name,
                            productPrice: convertToString(product.mainPrice),
                            brandLogo: product.brandLogoUrl,
                            productImageUrl: product.mainImage,
                            onTap: () {
                              ProductsBloc.get(context)
                                  .fetch_opened_product(product.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductDetails()),
                              );
                            },
                          ))
                      .toList(),
                ),
              ); // Default case
            }));
  }
}
/*
* BlocConsumer<
                                        ProductsBloc, ProductsState>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        print(state);
                                        // Builder is used to rebuild the UI based on the current state
                                        if (state is ProductsLoading) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (state
                                            is OpenedProductFetched) {
                                          print('found product: ${state.product}');
                                          return ProductDetails(
                                            productId: product.id,
                                            productName: product.name,
                                            productPrice: convertToString(
                                                product.mainPrice),
                                            brandLogo: product.brandLogoUrl,

                                            // Pass other necessary parameters to ProductDetails
                                          ); // Adjust as needed
                                        } else if (state is ProductsError) {
                                          // TODO: Handle error state
                                          return Center(
                                              child: Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Center(
                                              child: Text(
                                                state.errorMessage,
                                                style: const TextStyle(
                                                    fontFamily: 'Cairo-Bold',
                                                    fontSize: 40),
                                              ),
                                            ),
                                          ));
                                        }

                                        // Return a default widget if the state is not recognized
                                        return Text('m7slsh 7aga ya alb akhook');
                                      },
                                    ),
* */
