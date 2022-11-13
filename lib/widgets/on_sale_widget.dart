import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:growy/inner_screens/product_details.dart';
import 'package:growy/widgets/price_widget.dart';
import 'package:growy/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/viewed_product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import 'heart_btn.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              viewedProdProvider.addProductToHistory(
                  productId: productModel.id);
              Navigator.pushNamed(context, ProductDetails.routeName,
                  arguments: productModel.id);
              // GlobalMethods.navigateToProductDetails(
              //   ctx: context,
              //   routeName: ProductDetails.routeName,
              // );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    FancyShimmerImage(
                      imageUrl: productModel.imageUrl,
                      height: size.width * 0.22,
                      width: size.width * 0.22,
                      boxFit: BoxFit.fill,
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: productModel.isPiece ? '1 Piece' : '1KG',
                          color: color,
                          textSize: 20,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final User? user = authInstance.currentUser;
                                if (user == null) {
                                  GlobalMethods.errorDialog(
                                      subtitle:
                                          "No user found, Please login first",
                                      context: context);
                                  return;
                                }
                                await GlobalMethods.addToCard(
                                    productId: productModel.id,
                                    quantity: 1.0,
                                    context: context);
                                await cartProvider.fetchCart();
                                // cartProvider.addProductsToCart(
                                //     productId: productModel.id, quantity: 1.0);
                              },
                              child: Icon(
                                _isInCart
                                    ? IconlyBold.bag_2
                                    : IconlyLight.bag_2,
                                size: 24,
                                color: _isInCart ? Colors.green : color,
                              ),
                            ),
                            HeartBTN(
                              productId: productModel.id,
                              isInWishlist: _isInWishlist,
                            ),
                          ],
                        )
                      ],
                    )
                  ]),
                  PriceWidget(
                      salePrice: productModel.salePrice,
                      price: productModel.price,
                      textPrice: '1',
                      isOnSale: true),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: productModel.title,
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          )),
    );
  }
}
