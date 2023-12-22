import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'DataStructures.dart';
import 'States.dart';

class ProductsBloc extends Cubit<ProductsState> {
  ProductsBloc() : super(ProductsState());

  static ProductsBloc get(context) => BlocProvider.of(context);
  List<Product> products = []; //the mainProducts fetched
  List<String> openedProducts =
      []; //the products opened by the user to show the details, this is used to track whether making a new api call or not
  final String mainProductsApiUrl =
      'https://slash-backend.onrender.com/product';

  Future<Map<String, dynamic>> fetchUrl(apiUrl) async {
    final response = await http.get(Uri.parse(apiUrl));
    print('ApiUrl: $apiUrl response: $response');
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data

      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  void fetch_parse_main_products() async {
    try {
      emit(ProductsLoading());

      Map<String, dynamic> response = await fetchUrl(mainProductsApiUrl);

      products.clear();
      for (var item in response['data']) {
        double? tempPrice;
        String? tempImage;

        for (var variation in item['ProductVariations']) {
          if (variation['is_default']) {
            tempPrice = convertToDouble(variation['price']);
            tempImage = variation['ProductVarientImages'][0]['image_path'];
          }
        }

        Product tempProduct = Product(
          id: convertToString(item['id']),
          name: item['name'],
          mainPrice: tempPrice ??
              convertToDouble(item['ProductVariations'][0]['price']),
          mainImage: tempImage ??
              item['ProductVariations'][0]['ProductVarientImages'][0]
                  ['image_path'],
          brandLogoUrl: item['Brands']['brand_logo_image_path'],
        );

        products.add(tempProduct);
      }
      //for debugging
      //   for(var item in products){
      //     print(item.toString());
      //     print('*************************\n\n\n\n');
      //   }
      emit(MainProductsLoaded(products));
    } catch (e) {
      emit(ProductsError(
          errorMessage: 'Sorry, some error happened!\nPlease try again.'));
    }
  }

  void fetch_opened_product(String productID) async {
    int foundProductIndex = -1;
    for (int i = 0; i < products.length; i++) {
      if (products[i].id == productID) {
        foundProductIndex = i;
        break;
      }
    }

    if (foundProductIndex == -1) {
      emit(ProductNotFoundError(
          errorMessage: 'Sorry, this product isn\'t available now!\n'));
    } else if (products[foundProductIndex].productDetailsObject ==
            null //not fetched before->Fetch and set it then emit
        ) {
      try {
        emit(ProductsLoading());
        Map<String, dynamic> response =
            await fetchUrl('$mainProductsApiUrl/$productID');


          //parse the response, store it in the stored product in the main menu
          List<Variation> tempVariations = [];
          String variation_id = '-1';
          List<String> images = [];
          String name = response['data']['name'];
          double price = -1;
          String brandLogoUrl = response['data']['brandImage'];
          String brandName = response['data']['brandName'];

          Map<String, String> selectedOptions = {};
          String description = response['data']['description'];
          bool in_stock = true;
          List<Map<String, dynamic>> availableProps =
              response['avaiableProperties'];

          List<Map<String, dynamic>> uniqueProps = [];
          Set<String> uniquePropertySet = Set();

          for (var prop in availableProps) {
            if (uniquePropertySet.add(prop['property'])) {
              uniqueProps.add(prop);
            }
          }
          List<Variation> variations = [];
          for (var variation in response['data']['variations']) {
            if (variation['isDefault']) {
              variation_id = variation['id'];
              price = variation['price'];
              in_stock = variation['inStock'];
              images.clear();
              for (var image in variation['ProductVarientImages']) {
                images.add(image['image_path']);
              }
              for (var keyValue in variation['productPropertiesValues']) {
                selectedOptions[keyValue['property']] = keyValue['value'];
              }
            }
            Variation tempVariation = Variation(
                id: variation['id'],
                price: variation['price'],
                quantity: variation['quantity'],
                inStock: variation['inStock'],
                productVariantImages: variation['ProductVarientImages']
                    .map((e) => e['image_path'].toString())
                    .toList(),
                productPropertiesValues: variation['productPropertiesValues'],
                productStatus: variation['productStatus'],
                isDefault: variation['isDefault'],
                productVariationStatusId:
                    variation['product_variation_status_id']);
            tempVariations.add(tempVariation);
          }
          NavigationObject navigationObject = NavigationObject(
              availableProps: uniqueProps, selectedOptions: selectedOptions);
          products[foundProductIndex].productDetailsObject =
              ProductDetailsObject(
                  variation_id: variation_id,
                  images: images,
                  name: name,
                  price: price,
                  brandLogoUrl: brandLogoUrl,
                  brandName: brandName,
                  navigationObject: navigationObject,
                  description: description,
                  in_stock: in_stock,
                  variations: variations);
          emit(OpenedProductFetched(products[foundProductIndex]));


      } catch (e) {
        emit(ProductsError(
            errorMessage: 'Some error happened!\nPlease try agian later.'));
      }
    } else {
      //fetched before ->emit it
      emit(OpenedProductFetched(products[foundProductIndex]));
    }
  }
}

double convertToDouble(dynamic value) {
  if (value is double) {
    return value;
  } else if (value is int) {
    return value.toDouble();
  } else if (value is String) {
    return double.parse(value);
  } else {
    throw ArgumentError(
        "Invalid argument type, expected double, int, or String.");
  }
}

int convertToInt(dynamic value) {
  if (value is int) {
    return value;
  } else if (value is double) {
    return value.toInt();
  } else if (value is String) {
    return int.parse(value);
  } else {
    throw ArgumentError(
        "Invalid argument type, expected double, int, or String.");
  }
}

String convertToString(dynamic value) {
  if (value is String) {
    return value;
  } else if (value is int || value is double) {
    return value.toString();
  } else {
    throw ArgumentError(
        "Invalid argument type, expected double, int, or String.");
  }
}
