import 'package:flutter/material.dart';

import '../../../components/product_card.dart';
import '../../../models/Product.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Popular Products",
            press: () {
              Navigator.pushNamed(context, ProductsScreen.routeName);
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: List.generate(
              demoProducts.length,
                  (index) {
                if (demoProducts[index].isPopular) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: ProductCard(
                      product: demoProducts[index],
                      onPress: () => Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: ProductDetailsArguments(
                          product: demoProducts[index],
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }
}