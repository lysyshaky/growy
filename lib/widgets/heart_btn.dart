// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/consts/firebase_consts.dart';
import 'package:growy/providers/products_provider.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import 'package:growy/providers/wishlist_provider.dart';

import '../services/global_methods.dart';
import '../services/utils.dart';

class HeartBTN extends StatefulWidget {
  const HeartBTN({
    Key? key,
    required this.productId,
    this.isInWishlist = false,
  }) : super(key: key);
  final String productId;
  final bool? isInWishlist;

  @override
  State<HeartBTN> createState() => _HeartBTNState();
}

class _HeartBTNState extends State<HeartBTN> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.findProductById(widget.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return GestureDetector(
      onTap: () async {
        setState(() {
          loading = true;
        });
        try {
          final User? user = authInstance.currentUser;
          if (user == null) {
            GlobalMethods.errorDialog(
                subtitle: "No user found, Please login first",
                context: context);
            return;
          }
          if (widget.isInWishlist == false && widget.isInWishlist != null) {
            GlobalMethods.addToWishlist(
                productId: widget.productId, context: context);
          } else {
            await wishlistProvider.removeOneItem(
                productId: widget.productId,
                wishlistId: wishlistProvider
                    .getWishlistItems[getCurrentProduct.id]!.id);
          }
          await wishlistProvider.fetchWishlist();
          setState(() {
            loading = false;
          });
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {
          setState(() {
            loading = false;
          });
        }
        // wishlistProvider.addRemoveProductToWishlist(productId: productId);
      },
      child: loading
          ? const Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  )),
            )
          : Icon(
              widget.isInWishlist != null && widget.isInWishlist == true
                  ? IconlyBold.heart
                  : IconlyLight.heart,
              size: 24,
              color: widget.isInWishlist != null && widget.isInWishlist == true
                  ? Colors.red
                  : color,
            ),
    );
  }
}
