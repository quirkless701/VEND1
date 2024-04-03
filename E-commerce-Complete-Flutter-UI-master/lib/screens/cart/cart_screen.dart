import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/Cart.dart';
import 'components/cart_card.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    calculateTotal();
  }

  void calculateTotal() {
    double total = 0.0;
    for (var cartItem in demoCarts) {
      total += cartItem.product.price * cartItem.numOfItem;
    }
    setState(() {
      totalAmount = total;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              "Your Cart",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "${demoCarts.length} items",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                // Clear the demoCarts list to remove all items from the cart
                demoCarts.clear();
                calculateTotal();
              });
            },
          ),
        ],
      ),
      body: demoCarts.isEmpty
          ? Center(
        child: Text(
          "No items in the cart",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: demoCarts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Dismissible(
                key: Key(demoCarts[index].product.id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    demoCarts.removeAt(index);
                    calculateTotal(); // Ensure you recalculate total when removing an item
                  });
                },
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE6E6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      SvgPicture.asset("assets/icons/Trash.svg"),
                    ],
                  ),
                ),
                child: CartCard(
                  cart: demoCarts[index],
                  onRemove: () {
                    setState(() {
                      demoCarts.removeAt(index);
                      calculateTotal(); // Recalculate total after removing an item
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CheckoutCard(total: totalAmount,),
    );
  }
}
