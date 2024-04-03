import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/Product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.padding = 8.0,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double padding;
  final Product product;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          width: screenWidth - padding * 2,
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light grey background color
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          child: Row(
            children: [
              // Image
              Container(
                width: 100, // Adjust width as needed
                height: 100, // Adjust height as needed
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  image: DecorationImage(
                    image: AssetImage(product.images[0]), // Assuming image path is provided in product data
                    fit: BoxFit.fitWidth, // Adjust zoom level here
                  ),
                ),
              ),
              SizedBox(width: 16), // Adjust spacing between image and text
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "₹${product.price}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
