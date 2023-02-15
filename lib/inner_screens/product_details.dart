import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/providers/products_provider.dart';
import 'package:growy/widgets/heart_btn.dart';
import 'package:growy/widgets/price_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../models/product_model.dart';
import '../providers/dart_theme_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/viewed_product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/back_widget.dart';
import '../widgets/text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductsDetails';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    final Color appBarcolor = Utils(context).appBarcolor;
    Size size = Utils(context).getScreenSize;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final productProvider = Provider.of<ProductsProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findProdById(productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    double totalPrice = usedPrice * double.parse(_quantityTextController.text);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final languageProvider = Provider.of<LocaleProvider>(context);
    final locale = languageProvider.locale;
    return WillPopScope(
      onWillPop: () async {
        // viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0,
          backgroundColor: _isDark ? Colors.black12 : Colors.green,
          centerTitle: true,
          title: TextWidget(
            text: AppLocalizations.of(context)!.product_details,
            color: appBarcolor,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: Column(children: [
          Flexible(
            flex: 2,
            child: FancyShimmerImage(
              imageUrl: getCurrentProduct.imageUrl,
              height: size.width,
              width: size.width,
              boxFit: BoxFit.scaleDown,
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: locale.languageCode == "en"
                                ? getCurrentProduct.title
                                : getCurrentProduct.title_uk ??
                                    getCurrentProduct.title,
                            color: color,
                            textSize: 24,
                            isTitle: true,
                          ),
                        ),
                        HeartBTN(
                          productId: getCurrentProduct.id,
                          isInWishlist: _isInWishlist,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: "${usedPrice.toStringAsFixed(2)}\ ₴/",
                          color: Colors.green,
                          textSize: 22,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: getCurrentProduct.isPiece
                              ? AppLocalizations.of(context)!.piece
                              : AppLocalizations.of(context)!.kg,
                          color: color,
                          textSize: 14,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: getCurrentProduct.isOnSale ? true : false,
                          child: Text(
                            "${getCurrentProduct.price.toStringAsFixed(2)}\ ₴",
                            style: TextStyle(
                              fontSize: 16,
                              color: color,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.green,
                          ),
                          child: TextWidget(
                            text: AppLocalizations.of(context)!.free_delivery,
                            color: Colors.white,
                            textSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      _quantityController(
                        icon: CupertinoIcons.minus,
                        color: Colors.red,
                        fct: () {
                          if (_quantityTextController.text == '1.0') {
                            return;
                          } else {
                            setState(() {
                              _quantityTextController.text =
                                  (double.parse(_quantityTextController.text) -
                                          1.0)
                                      .toString();
                            });
                          }
                        },
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                            controller: _quantityTextController,
                            key: const ValueKey('quantity'),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.green,
                            enabled: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[0-9].'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  _quantityTextController.text = '1.0';
                                } else {}
                              });
                            }),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      _quantityController(
                          color: Colors.green,
                          icon: CupertinoIcons.plus,
                          fct: () {
                            setState(() {
                              _quantityTextController.text =
                                  (double.parse(_quantityTextController.text) +
                                          1.0)
                                      .toString();
                            });
                          }),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: AppLocalizations.of(context)!.total,
                                  color: Colors.red.shade300,
                                  textSize: 20,
                                  isTitle: true,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        text:
                                            '${totalPrice.toStringAsFixed(2)}\ ₴/',
                                        color: color,
                                        textSize: 20,
                                        isTitle: true,
                                      ),
                                      TextWidget(
                                        text:
                                            '${_quantityTextController.text} ${getCurrentProduct.isPiece ? AppLocalizations.of(context)!.piece : AppLocalizations.of(context)!.kg}',
                                        color: color,
                                        textSize: 16,
                                        isTitle: false,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Material(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: _isInCart
                                    ? null
                                    : () async {
                                        final User? user =
                                            authInstance.currentUser;
                                        if (user == null) {
                                          GlobalMethods.errorDialog(
                                              subtitle:
                                                  AppLocalizations.of(context)!
                                                      .no_user,
                                              context: context);
                                          return;
                                        }
                                        await GlobalMethods.addToCard(
                                            productId: getCurrentProduct.id,
                                            quantity: double.parse(
                                                _quantityTextController.text),
                                            context: context);
                                        await cartProvider.fetchCart();
                                        // cartProvider.addProductsToCart(
                                        //     productId: getCurrentProduct.id,
                                        //     quantity: double.parse(
                                        //         _quantityTextController.text));
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextWidget(
                                    text: _isInCart
                                        ? AppLocalizations.of(context)!.in_cart
                                        : AppLocalizations.of(context)!
                                            .add_to_cart,
                                    color: Colors.white,
                                    textSize: 20,
                                    isTitle: true,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          )
        ]),
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
