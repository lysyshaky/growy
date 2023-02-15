import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growy/consts/firebase_consts.dart';
import 'package:growy/providers/products_provider.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../inner_screens/product_details.dart';
import '../../providers/dart_theme_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';
import 'cart_widget.dart';
import '../../widgets/empty_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        ? EmptyScreen(
            title: AppLocalizations.of(context)!.your_cart_empty,
            subtitle: AppLocalizations.of(context)!.add_something_cart,
            buttonText: AppLocalizations.of(context)!.shop_now_btn,
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
                          title: AppLocalizations.of(context)!.clear_cart,
                          subtitle: AppLocalizations.of(context)!
                              .do_you_want_to_clear_cart,
                          fct: () async {
                            await cartProvider.clearOnlineCart();
                            cartProvider.clearLocalCart();
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
                text: AppLocalizations.of(context)!.cart +
                    "(${cartItemsList.length})",
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
                      itemBuilder: (context, index) {
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
  final cartProvider = Provider.of<CartProvider>(context);

  final productProvider = Provider.of<ProductsProvider>(context, listen: false);
  final ordersProvider = Provider.of<OrdersProvider>(context);
  double total = 0.0;

  cartProvider.getCartItems.forEach((key, value) {
    final getCurrentProduct = productProvider.findProdById(value.productId);
    total += (getCurrentProduct.isOnSale
            ? getCurrentProduct.salePrice
            : getCurrentProduct.price) *
        value.quantity;
  });
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
              onTap: () async {
                User? user = authInstance.currentUser;

                final orderId = const Uuid().v4();

                cartProvider.getCartItems.forEach((key, value) async {
                  final getCurrentProduct =
                      productProvider.findProdById(value.productId);
                  try {
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(getCurrentProduct.id)
                        .set({
                      'orderId': orderId,
                      'userId': user!.uid,
                      'productId': value.productId,
                      'price': (getCurrentProduct.isOnSale
                              ? getCurrentProduct.salePrice
                              : getCurrentProduct.price) *
                          value.quantity,
                      'totalPrice': total,
                      'quantity': value.quantity,
                      'imageUrl': getCurrentProduct.imageUrl,
                      'userName': user.displayName,
                      'orderDate': Timestamp.now(),
                    });
                    await cartProvider.clearOnlineCart();
                    cartProvider.clearLocalCart();
                    await ordersProvider.fetchOrders();
                  } catch (error) {
                    GlobalMethods.errorDialog(
                        subtitle: error.toString(), context: context);
                  } finally {}
                });
                await Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.order_placed,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.green,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextWidget(
                  text: AppLocalizations.of(context)!.order_now,
                  textSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Spacer(),
          FittedBox(
            child: TextWidget(
              text: AppLocalizations.of(context)!.total_order +
                  "${total.toStringAsFixed(2)}\ ₴",
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
