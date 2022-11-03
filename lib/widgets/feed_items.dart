import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/inner_screens/product_details.dart';
import 'package:growy/models/product_model.dart';
import 'package:growy/widgets/price_widget.dart';
import 'package:growy/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import 'heart_btn.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateToProductDetails(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                height: size.width * 0.17,
                width: size.width * 0.2,
                boxFit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextWidget(
                        text: productModel.title,
                        color: color,
                        textSize: 18,
                        maxLines: 1,
                        isTitle: true,
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: HeartBTN(
                          productId: productModel.id,
                          isInWishlist: _isInWishlist,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: PriceWidget(
                            salePrice: productModel.salePrice,
                            price: productModel.price,
                            textPrice: _quantityTextController.text,
                            isOnSale: productModel.isOnSale,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true, //<-- SEE HERE
                              fillColor: Colors.green.shade300,
                              //<-- SEE HERE
                            ),
                            controller: _quantityTextController,
                            key: const ValueKey('10 \$'),
                            style: TextStyle(
                              color: color,
                              fontSize: 18,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Quantity is missed';
                              }
                              return null;
                            },
                            maxLines: 1,
                            enabled: true,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.green,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  _quantityTextController.text = '1';
                                } else {
                                  // total = usedPrice *
                                  //     int.parse(_quantityTextController.text);
                                }
                              });
                            },
                            onSaved: (value) {},
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: FittedBox(
                            child: TextWidget(
                              text: productModel.isPiece ? 'Piece' : 'KG',
                              color: color,
                              textSize: 20,
                              isTitle: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              //customize button and all colors in dark theme
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isInCart
                      ? null
                      : (() {
                          // if (_isInCart) {
                          //   return;
                          // }
                          final User? user = authInstance.currentUser;
                          if (user == null) {
                            GlobalMethods.errorDialog(
                                subtitle: "No user found, Please login first",
                                context: context);
                            return;
                          }
                          cartProvider.addProductsToCart(
                              productId: productModel.id,
                              quantity:
                                  double.parse(_quantityTextController.text));
                        }),
                  child: TextWidget(
                    text: _isInCart ? 'In cart' : 'Add to cart',
                    textSize: 20,
                    color: color,
                    isTitle: true,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
