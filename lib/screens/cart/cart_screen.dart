import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/product_details.dart';
import '../../provider/dart_theme_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';
import 'cart_widget.dart';
import '../../widgets/empty_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final utils = Utils(context);
    Color color = utils.appBarcolor;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();

    return cartItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your car is empty!',
            subtitle: 'Add something to your cart',
            buttonText: 'Shop now',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    onPressed: () async {
                      await GlobalMethods.warningDialog(
                          title: 'Clear cart',
                          subtitle: 'Do you wanna clear your cart?',
                          fct: () {
                            cartProvider.clearCart();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyLight.delete,
                      color: color,
                    ),
                  ),
                )
              ],
              elevation: 0,
              backgroundColor: _isDark ? Colors.black12 : Colors.green,
              centerTitle: true,
              title: TextWidget(
                text: 'Cart(${cartItemsList.length})',
                color: color,
                textSize: 24,
                isTitle: true,
              ),
            ),
            body: Column(
              children: [
                _checkout(context: context),
                Expanded(
                  child: ListView.builder(
                      itemCount: cartItemsList.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: cartItemsList[index],
                            child: CartWidget(
                              quantity: cartItemsList[index].quantity,
                            ));
                      }),
                ),
              ],
            ),
          );
  }
}

Widget _checkout({required BuildContext context}) {
  final utils = Utils(context);
  Color color = utils.color;
  Size size = Utils(context).getScreenSize;
  return SizedBox(
    width: double.infinity,
    height: size.height * 0.1,
    //color:
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextWidget(
                  text: "Order Now",
                  textSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          FittedBox(
            child: TextWidget(
              text: "Total: \$0.259",
              color: color,
              textSize: 20,
              isTitle: true,
            ),
          ),
        ],
      ),
    ),
  );
}
