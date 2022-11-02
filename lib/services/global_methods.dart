import 'package:flutter/material.dart';
import 'package:growy/inner_screens/feeds_screen.dart';
import 'package:growy/inner_screens/product_details.dart';
import 'package:growy/screens/home_screen.dart';
import 'package:growy/screens/orders/orders_screen.dart';
import 'package:growy/screens/viewed/viewed_screen.dart';
import 'package:growy/screens/wishlist/wishlist_screen.dart';

import '../inner_screens/on_sale_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/btm_bar.dart';
import '../widgets/text_widget.dart';

class GlobalMethods {
  static navigateToViewAll(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, OnSaleScreen.routeName);
  }

  static navigateToBrowseAll(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, FeedsScreen.routeName);
  }

  static navigateToProductDetails(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, ProductDetails.routeName);
  }

  static navigateToWishlist(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, WishlistScreen.routeName);
  }

  static navigateToOrders(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, OrdersScreen.routeName);
  }

  static navigateToViewed(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, ViewedScreen.routeName);
  }

  static navigateToHomeScreen(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, BottomBarScreen.routeName);
  }

  static navigateToRegister(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, RegisterScreen.routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset('assets/images/warning-sign.png',
                    height: 24, width: 24, fit: BoxFit.fill),
                const SizedBox(
                  width: 8,
                ),
                Text(title),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.green,
                  text: 'Cancel',
                  textSize: 18,
                  isTitle: true,
                ),
              ),
              TextButton(
                onPressed: () {
                  fct();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.red,
                  text: 'OK',
                  textSize: 18,
                  isTitle: true,
                ),
              ),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset('assets/images/warning-sign.png',
                    height: 24, width: 24, fit: BoxFit.fill),
                const SizedBox(
                  width: 8,
                ),
                const Text("An Error occured"),
              ],
            ),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.green,
                  text: 'OK',
                  textSize: 18,
                  isTitle: true,
                ),
              ),
            ],
          );
        });
  }
}
