import 'package:bloc/bloc.dart';

/// Data structures
class Product {
  String id;
  String name;
  double mainPrice; //the price shown in the landing page, NOT SHOWN IN THE PRODUCT DETAILS
  String mainImage;
  String brandLogoUrl;
  ProductDetailsObject?
      productDetailsObject; //this object will be the object that the products screen will read from, if it's changed then the products screen components will be changed

  Product({
    required this.id,
    required this.name,
    required this.mainPrice,
    required this.mainImage,
    required this.brandLogoUrl,
    this.productDetailsObject,
  });

  @override
  String toString() {
    // for debugging
    return '''
    Product Attributes:
      ID: $id
      Name: $name
      Main Price: $mainPrice
      Main Image: $mainImage
      Brand Logo URL: $brandLogoUrl
      Product Details: $productDetailsObject
    ''';
  }
}

class ProductDetailsObject {
  String variation_id;
  List<String> images;
  String name;
  double price;
  String brandLogoUrl;
  String brandName;
  NavigationObject navigationObject;
  String description;
  bool in_stock;
  List<Variation> variations;

  ProductDetailsObject({
    required this.variation_id, // the id of the shown variation
    required this.images,
    required this.name,
    required this.price,
    required this.brandLogoUrl,
    required this.brandName,
    required this.navigationObject,
    required this.description,
    required this.in_stock,
    required this.variations,
  });

  @override
  String toString() {
    return '''
  ProductDetailsObject:
    Variation ID: $variation_id
    Name: $name
    Price: $price
    Brand Name: $brandName
    Navigation Object: $navigationObject
    Description: $description
    In Stock: $in_stock
    Variations: ${variations.map((element) => element.toString()).join('\n')}
  ''';
  }
}

class NavigationObject {
  final List<Map<String, dynamic>> availableProps;
  Map<String, String> selectedOptions;

  NavigationObject({
    required this.availableProps,
    required this.selectedOptions,
  });

  @override
  String toString() {
    return '''
    NavigationObject:
      Available Properties: $availableProps
      Selected Options: $selectedOptions
    ''';
  }
}

class Variation {
  final int id;
  final double price;
  final int quantity;
  final bool inStock;
  final List<String> productVariantImages;
  final List<dynamic> productPropertiesValues;
  final String productStatus;
  final bool isDefault;
  final int productVariationStatusId;

  Variation({
    required this.id,
    required this.price,
    required this.quantity,
    required this.inStock,
    required this.productVariantImages,
    required this.productPropertiesValues,
    required this.productStatus,
    required this.isDefault,
    required this.productVariationStatusId,
  });

  @override
  String toString() {
    return '''
    Variation:
      ID: $id
      Price: $price
      Quantity: $quantity
      In Stock: $inStock
      Product Properties Values: $productPropertiesValues
      Product Status: $productStatus
      Is Default: $isDefault
      Product Variation Status ID: $productVariationStatusId
    ''';
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}

void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern
      .allMatches(text)
      .forEach((RegExpMatch match) => print(match.group(0)));
}
