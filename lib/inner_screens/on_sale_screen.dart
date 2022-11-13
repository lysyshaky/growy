import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/widgets/back_widget.dart';
import 'package:growy/widgets/on_sale_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/dart_theme_provider.dart';
import '../providers/products_provider.dart';
import '../services/utils.dart';
import '../widgets/empty_product_widget.dart';
import '../widgets/text_widget.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isEmpty = false;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    final Utils utils = Utils(context);
    final Color color = Utils(context).appBarcolor;
    Size size = Utils(context).getScreenSize;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;

    return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0,
          backgroundColor: _isDark ? Colors.black12 : Colors.green,
          centerTitle: true,
          title: TextWidget(
            text: 'Products on sale',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: productsOnSale.isEmpty
            ? const EmptyProductWidget(
                text: 'No products on sale yet!\nStay tuned')
            : GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                // crossAxisSpacing: 10,
                childAspectRatio: size.width / (size.height * 0.45),

                children: List.generate(productsOnSale.length, (index) {
                  return ChangeNotifierProvider.value(
                      value: productsOnSale[index],
                      child: const OnSaleWidget());
                }),
              ));
  }
}
