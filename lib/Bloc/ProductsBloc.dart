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

  int searchIndex(productID) {
    int foundProductIndex = -1;
    for (int i = 0; i < products.length; i++) {
      if (products[i].id == productID) {
        foundProductIndex = i;
        break;
      }
    }
    return foundProductIndex;
  }

  void fetch_opened_product(String productID) async {
    int foundProductIndex = searchIndex(productID);

    if (foundProductIndex == -1) {
      emit(ProductNotFoundError(
          errorMessage: 'Sorry, this product isn\'t available now!\n'));
    } else if (products[foundProductIndex].productDetailsObject ==
            null //not fetched before->Fetch and set it then emit
        ) {
      emit(ProductsLoading());
      Map<String, dynamic> response =
          await fetchUrl('$mainProductsApiUrl/$productID');
      try {
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
        List<dynamic> availableProps = response['data']['avaiableProperties'];

        List<Map<String, dynamic>> uniqueProps = [];
        Set<String> uniquePropertySet = Set();

        for (var prop in availableProps) {
          if (uniquePropertySet.add(prop['property'])) {
            uniqueProps.add(prop);
          }
        }

        for (var variation in response['data']['variations']) {
          if (variation['isDefault']) {
            variation_id = convertToString(variation['id']);
            price = convertToDouble(variation['price']);
            in_stock = variation['inStock'];
            images.clear();
            for (var image in variation['ProductVarientImages']) {
              images.add(image['image_path']);
            }
            for (var keyValue in variation['productPropertiesValues']) {
              selectedOptions[keyValue['property']] = keyValue['value'];
            }
          }
          List<String> imagePathList =
              (variation['ProductVarientImages'] as List<dynamic>)
                  .map((imageMap) => imageMap['image_path'].toString())
                  .toList();

          Variation tempVariation = Variation(
              id: variation['id'],
              price: convertToDouble(variation['price']),
              quantity: convertToInt(variation['quantity']),
              inStock: variation['inStock'],
              productVariantImages: imagePathList,
              productPropertiesValues: variation['productPropertiesValues'],
              productStatus: variation['productStatus'],
              isDefault: variation['isDefault'],
              productVariationStatusId:
                  variation['product_variation_status_id']);
          tempVariations.add(tempVariation);
        }
        NavigationObject navigationObject = NavigationObject(
            availableProps: uniqueProps, selectedOptions: selectedOptions);
        products[foundProductIndex].productDetailsObject = ProductDetailsObject(
            variation_id: variation_id,
            images: images,
            name: name,
            price: price,
            brandLogoUrl: brandLogoUrl,
            brandName: brandName,
            navigationObject: navigationObject,
            description: description,
            in_stock: in_stock,
            variations: tempVariations);

        emit(OpenedProductFetched(products[foundProductIndex]));
      } catch (e) {
        print(e);
        emit(ProductsError(
            errorMessage: 'Some error happened!\nPlease try again.'));
      }
    } else {
      //fetched before ->emit it

      emit(OpenedProductFetched(products[foundProductIndex]));
    }
  }

  void handleOptionButton(String currentVariationId,
      Map<String, String> selectedOptions, String productId) {}

  void changeVariation(Product product, Variation newVariation) {
    product.productDetailsObject?.price = newVariation.price;
    product.productDetailsObject?.variation_id =
        convertToString(newVariation.id);
    product.productDetailsObject?.images = newVariation.productVariantImages;
  }

  void searchVariation(String currentVariationId,
      Map<String, String> selectedOptions, String productId) {
    print(
        'search variation is called\nselectedOptions: ${selectedOptions}\ncurrent: $currentVariationId');

    int foundProductIndex = searchIndex(productId);

    if (foundProductIndex != -1) {
      Product product = products[foundProductIndex];

      // Find the variation that matches the selected options
      Variation? selectedVariation;

      for (Variation variation
          in product.productDetailsObject?.variations ?? []) {
        Map<String, String> variationOptions = {};

        for (Map<String, dynamic> propertyValue
            in variation.productPropertiesValues) {
          variationOptions[propertyValue['property']] = propertyValue['value'];
        }

        if (selectedOptions.entries.every((entry) =>
            variationOptions.containsKey(entry.key) &&
            variationOptions[entry.key] == entry.value)) {
          selectedVariation = variation;
          print('found variation : $selectedVariation');

          if (currentVariationId != selectedVariation.id.toString()) {
            changeVariation(products[foundProductIndex], selectedVariation);
            emit(VariationChanged(product: products[foundProductIndex]));
            return;
          }
          return;
        }
      }

      // Check if the selected variation is different from the current one
    }
    return;
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
