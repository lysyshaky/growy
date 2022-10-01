import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:growy/inner_screens/product_details.dart';
import 'package:growy/widgets/price_widget.dart';
import 'package:growy/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          color: Theme.of(context).cardColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              GlobalMethods.navigateToProductDetails(
                ctx: context,
                routeName: ProductDetails.routeName,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    FancyShimmerImage(
                      imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
                      height: size.width * 0.22,
                      width: size.width * 0.22,
                      boxFit: BoxFit.fill,
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: '1KG',
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
                              onTap: () {},
                              child: Icon(
                                IconlyLight.bag_2,
                                size: 24,
                                color: color,
                              ),
                            ),
                            const HeartBTN(),
                          ],
                        )
                      ],
                    )
                  ]),
                  const PriceWidget(
                      salePrice: 5.59,
                      price: 2.99,
                      textPrice: '1',
                      isOnSale: true),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: 'Product title',
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
