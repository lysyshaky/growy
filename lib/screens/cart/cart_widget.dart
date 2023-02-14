// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import 'package:growy/models/cart_model.dart';
import 'package:growy/providers/products_provider.dart';

import '../../inner_screens/product_details.dart';
import '../../models/product_model.dart';
import '../../providers/dart_theme_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({
    Key? key,
    required this.quantity,
  }) : super(key: key);
  final double quantity;
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = widget.quantity.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final languageProvider = Provider.of<LocaleProvider>(context);
    final locale = languageProvider.locale;
    final getCurrentProduct = productProvider.findProdById(cartModel.productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.imageUrl,
                        boxFit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: locale.languageCode == "en"
                              ? getCurrentProduct.title
                              : getCurrentProduct.title_uk ??
                                  getCurrentProduct.title,
                          color: color,
                          textSize: 20,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          child: Row(
                            children: [
                              _quantityController(
                                fct: () {
                                  cartProvider
                                      .reduceQuantityByOne(cartModel.productId);
                                  if (_quantityTextController.text == '1.0') {
                                    return;
                                  } else {
                                    setState(() {
                                      _quantityTextController.text =
                                          (double.parse(_quantityTextController
                                                      .text) -
                                                  1)
                                              .toString();
                                    });
                                  }
                                },
                                color: Colors.red,
                                icon: CupertinoIcons.minus,
                              ),
                              Flexible(
                                flex: 1,
                                child: TextField(
                                  controller: _quantityTextController,
                                  keyboardType: TextInputType.number,
                                  // Maybe make it only INT datatype, remove .
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.]')),
                                  ],
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(),
                                    ),
                                  ),
                                  onChanged: (v) {
                                    setState(() {
                                      if (v.isEmpty) {
                                        _quantityTextController.text = '1.0';
                                      } else {
                                        return;
                                      }
                                    });
                                  },
                                ),
                              ),
                              _quantityController(
                                fct: () {
                                  cartProvider.increaseQuantityByOne(
                                      cartModel.productId);
                                  setState(() {
                                    _quantityTextController
                                        .text = (double.parse(
                                                _quantityTextController.text) +
                                            1)
                                        .toString();
                                  });
                                },
                                color: Colors.green,
                                icon: CupertinoIcons.plus,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await cartProvider.removeOneItem(
                                  cartId: cartModel.id,
                                  productId: cartModel.productId,
                                  quantity: cartModel.quantity);
                            },
                            child: const Icon(CupertinoIcons.cart_badge_minus,
                                color: Colors.red),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          HeartBTN(
                            productId: getCurrentProduct.id,
                            isInWishlist: _isInWishlist,
                          ),
                          TextWidget(
                            text:
                                '${(usedPrice * double.parse(_quantityTextController.text)).toStringAsFixed(2)}\₴',
                            color: color,
                            textSize: 18,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _quantityController({
  required Function fct,
  required IconData icon,
  required Color color,
}) {
  return Flexible(
    flex: 2,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            fct();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    ),
  );
}
