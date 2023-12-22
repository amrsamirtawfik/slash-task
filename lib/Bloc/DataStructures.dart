
import 'package:bloc/bloc.dart';

///data structures
class Product {
  final String id;
  final String name;
  final double mainPrice;
  final String mainImage;
  final String brandLogoUrl;
  ProductDetailsObject? productDetailsObject;

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
  final String variation_id;
  final List<String> images;
  final String name;
  final double price;
  final String brandLogoUrl;
  final String brandName;
  final NavigationObject navigationObject;
  final String description;
  final bool in_stock;
  final List<Variation> variations;

  ProductDetailsObject({
    required this.variation_id, //the id of the shown variation
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
}

class NavigationObject {
  final List<Map<String,dynamic>> availableProps;
  Map<String, String> selectedOptions;

  NavigationObject(
      {required this.availableProps, required this.selectedOptions});
}

class Variation {
  final int id;
  final double price;
  final int quantity;
  final bool inStock;
  final List<String> productVariantImages;
  final List<Map<String,dynamic>> productPropertiesValues;
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
}



// class ProductPropertyValue {
//   final String value;
//   final String property;
//
//   ProductPropertyValue({
//     required this.value,
//     required this.property,
//   });
// }

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