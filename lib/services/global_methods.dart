import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growy/inner_screens/feeds_screen.dart';
import 'package:growy/inner_screens/product_details.dart';
import 'package:growy/screens/home_screen.dart';
import 'package:growy/screens/orders/orders_screen.dart';
import 'package:growy/screens/viewed/viewed_screen.dart';
import 'package:growy/screens/wishlist/wishlist_screen.dart';
import 'package:uuid/uuid.dart';

import '../consts/firebase_consts.dart';
import '../inner_screens/on_sale_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/btm_bar.dart';
import '../widgets/text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  text: AppLocalizations.of(context)!.cancel,
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
                  text: AppLocalizations.of(context)!.ok,
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
                Text(
                  AppLocalizations.of(context)!.error,
                ),
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
                  text: AppLocalizations.of(context)!.ok,
                  textSize: 18,
                  isTitle: true,
                ),
              ),
            ],
          );
        });
  }

  static Future<void> addToCard({
    required String productId,
    required double quantity,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final cartId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userCart': FieldValue.arrayUnion([
          {'cartId': cartId, 'productId': productId, 'quantity': quantity}
        ])
      });
      await Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.cart_toast,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          gravity: ToastGravity.CENTER);
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }

  static Future<void> addToWishlist({
    required String productId,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final wishlistId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      await Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.wishlist_toast,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          gravity: ToastGravity.CENTER);
    } catch (error) {
      errorDialog(subtitle: error.toString(), context: context);
    }
  }
}
