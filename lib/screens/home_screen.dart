import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/inner_screens/feeds_screen.dart';
import 'package:growy/inner_screens/on_sale_screen.dart';
import 'package:growy/providers/dart_theme_provider.dart';
import 'package:growy/services/global_methods.dart';
import 'package:growy/widgets/feed_items.dart';
import 'package:growy/widgets/on_sale_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../consts/consts.dart';
import '../models/product_model.dart';
import '../providers/products_provider.dart';
import '../services/utils.dart';
import '../widgets/text_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Consts.offerImages[index],
                    fit: BoxFit.fill,
                  );
                },
                itemCount: Consts.offerImages.length,
                pagination: const SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                      color: Colors.white, activeColor: Colors.green),
                ),
                //contoller buttons for ImagesSlider
                //control: SwiperControl(),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            TextButton(
              onPressed: () {
                GlobalMethods.navigateToViewAll(
                  ctx: context,
                  routeName: OnSaleScreen.routeName,
                );
              },
              child: TextWidget(
                text: AppLocalizations.of(context)!.view_all,
                maxLines: 1,
                color: Colors.green,
                textSize: 20,
              ),
            ),
            Row(
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Row(children: [
                    TextWidget(
                      text: AppLocalizations.of(context)!.on_sale,
                      color: Colors.red,
                      textSize: 22,
                      isTitle: true,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      IconlyLight.discount,
                      color: Colors.red,
                      size: 24,
                    ),
                  ]),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: SizedBox(
                    height: size.height * 0.24,
                    child: ListView.builder(
                      itemCount: productsOnSale.length < 10
                          ? productsOnSale.length
                          : 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: productsOnSale[index],
                            child: const OnSaleWidget());
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: AppLocalizations.of(context)!.our_products,
                    color: color,
                    textSize: 22,
                    isTitle: true,
                  ),
                  //const Spacer(), //vertical
                  TextButton(
                    onPressed: () {
                      GlobalMethods.navigateToBrowseAll(
                          ctx: context, routeName: FeedsScreen.routeName);
                    },
                    child: TextWidget(
                      text: AppLocalizations.of(context)!.browse_all,
                      maxLines: 1,
                      color: Colors.green,
                      textSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.65),
              children: List.generate(
                  allProducts.length < 4 ? allProducts.length : 4, (index) {
                return ChangeNotifierProvider.value(
                    value: allProducts[index], child: const FeedsWidget());
              }),
            )
          ],
        ),
      ),
    );
  }
}
