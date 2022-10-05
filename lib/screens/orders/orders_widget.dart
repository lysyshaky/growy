import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:provider/provider.dart';

import '../../inner_screens/product_details.dart';
import '../../provider/dart_theme_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return ListTile(
      subtitle: const Text('Paid: \$12.88'),
      onTap: () {
        GlobalMethods.navigateToProductDetails(
            ctx: context, routeName: ProductDetails.routeName);
      },
      leading: Container(
        height: size.width * 0.2,
        width: size.width * 0.2,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
        child: FancyShimmerImage(
          imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
          boxFit: BoxFit.fill,
        ),
      ),
      title: TextWidget(
        text: 'Title x12',
        color: color,
        textSize: 20,
        isTitle: true,
      ),
      trailing: TextWidget(text: '03/08/2022', color: color, textSize: 16),
    );
  }
}
