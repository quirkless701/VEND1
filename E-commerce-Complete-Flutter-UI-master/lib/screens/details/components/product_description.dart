import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/Product.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Added padding under the product title
          child: Text(
            widget.product.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Added padding under the product description
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expanded ? widget.product.description : widget.product.description.substring(0, 100), // Display only first 100 characters when not expanded
                style: Theme.of(context).textTheme.bodyText2,
              ),
              if (expanded) SizedBox(height: 8), // Added space between expanded description and "See More" button
            ],
          ),
        ),
        if (!expanded)
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 12, // Added bottom padding
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  expanded = true;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20), // Rounded bottom-left corner
                    bottomRight: Radius.circular(20), // Rounded bottom-right corner
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "See More Detail",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
