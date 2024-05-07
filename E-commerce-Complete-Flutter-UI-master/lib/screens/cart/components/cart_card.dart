import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../models/Cart.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  final Cart cart;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(cart.product.images[0]),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.product.title,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${cart.product.price}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                        fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                      ),
                    ),
                    Row(
                      children: [
                        MaterialButton(
                          onPressed: () {
                            if (cart.numOfItem > 1) {
                              onDecrement();
                            } else {
                              onRemove();
                            }
                          },
                          padding: EdgeInsets.zero,
                          minWidth: 30,
                          height: 30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: kPrimaryColor),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: kPrimaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            cart.numOfItem.toString(),
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: onIncrement,
                          padding: EdgeInsets.zero,
                          minWidth: 30,
                          height: 30,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: kPrimaryColor),
                          ),
                          child: Icon(
                            Icons.add,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
