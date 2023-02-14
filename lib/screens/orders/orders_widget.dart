import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/models/orders_model.dart';

import 'package:provider/provider.dart';

import '../../inner_screens/product_details.dart';
import '../../providers/dart_theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final productProvider = Provider.of<ProductsProvider>(context);

    final getCurrentProduct =
        productProvider.findProdById(ordersModel.productId);
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final languageProvider = Provider.of<LocaleProvider>(context);
    final locale = languageProvider.locale;
    return GestureDetector(
      child: ListTile(
        subtitle: Text(AppLocalizations.of(context)!.paid +
            '${double.parse(ordersModel.price).toStringAsFixed(2)}\₴'),
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: ordersModel.productId);
        },
        leading: Container(
          height: size.width * 0.2,
          width: size.width * 0.2,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
          child: FancyShimmerImage(
            imageUrl: getCurrentProduct.imageUrl,
            boxFit: BoxFit.fill,
          ),
        ),
        title: TextWidget(
          text:
              '${locale.languageCode == "en" ? getCurrentProduct.title : getCurrentProduct.title_uk ?? getCurrentProduct.title} x${ordersModel.quantity}',
          color: color,
          textSize: 20,
          isTitle: true,
        ),
        trailing: TextWidget(text: orderDateToShow, color: color, textSize: 16),
      ),
    );
  }
}
