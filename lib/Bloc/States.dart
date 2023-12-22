import 'DataStructures.dart';

class ProductsState {}

class ProductsLoading extends ProductsState {}

class MainProductsLoaded extends ProductsState {
  final List<Product> products;

  MainProductsLoaded(this.products);
}

class OpenedProductFetched extends ProductsState {
  final Product product;

  OpenedProductFetched(this.product);
}
class ProductsError extends ProductsState { //if any error happens during fetching apis
  final String errorMessage;

  ProductsError({required this.errorMessage});
}

class ProductNotFoundError extends ProductsState { //this is emitted when trying to open a product from the landing page and not found
  final String errorMessage;

  ProductNotFoundError({required this.errorMessage});
}
