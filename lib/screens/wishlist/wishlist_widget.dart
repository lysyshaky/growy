import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/models/wishlist_model.dart';
import 'package:growy/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/product_details.dart';
import '../../models/product_model.dart';
import '../../provider/dart_theme_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final utils = Utils(context);
    Color color = utils.color;
    Size size = Utils(context).getScreenSize;

    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct =
        productProvider.findProductById(wishlistModel.productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;

    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.6),
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  // width: size.width * 0.2,
                  height: size.width * 0.25,
                  child: FancyShimmerImage(
                    imageUrl: getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(IconlyLight.bag_2, color: color),
                          ),
                          HeartBTN(
                            productId: getCurrentProduct.id,
                            isInWishlist: _isInWishlist,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      getCurrentProduct.title,
                      maxLines: 2,
                      style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    TextWidget(
                      text: '\$${usedPrice.toStringAsFixed(2)}',
                      color: color,
                      textSize: 18.0,
                      maxLines: 2,
                      isTitle: true,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
