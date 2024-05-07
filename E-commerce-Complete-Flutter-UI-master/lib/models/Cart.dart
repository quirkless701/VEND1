import 'Product.dart';

class Cart {
  final Product product;
  int numOfItem; // Remove 'final' keyword to make it mutable

  Cart({required this.product, required this.numOfItem});
}

// Demo data for our cart

List<Cart> demoCarts = [];
