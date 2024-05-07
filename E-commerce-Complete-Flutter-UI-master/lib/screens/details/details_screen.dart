import 'package:flutter/material.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';

import '../../models/Product.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';

class DetailsScreen extends StatefulWidget {
  static String routeName = "/details";

  const DetailsScreen({Key? key}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int selectedQuantity = 1; // Default quantity selected

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs =
    ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    final product = agrs.product;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          ProductImages(product: product),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(
                  product: product,
                  pressOnSeeMore: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildQuantityDropdown(),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Check if the product already exists in the cart
                    bool productExistsInCart = demoCarts.any((cart) => cart.product == product);

                    if (!productExistsInCart) {
                      // Add the product to the cart list with selected quantity
                      demoCarts.add(Cart(product: product, numOfItem: selectedQuantity));

                      // Show a snackbar to indicate that the product was added to the cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product added to cart')),
                      );
                    } else {
                      // Show a snackbar to indicate that the product is already in the cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product is already in cart')),
                      );
                    }
                  },
                  child: const Text("Add To Cart"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8),
        DropdownButton<int>(
          value: selectedQuantity,
          onChanged: (value) {
            setState(() {
              selectedQuantity = value!;
            });
          },
          items: List.generate(
            5, // Change this value as needed to set the maximum quantity
                (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Text('${index + 1}'),
            ),
          ),
        ),
      ],
    );
  }




}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}