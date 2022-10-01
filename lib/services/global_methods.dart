import 'package:flutter/material.dart';
import 'package:growy/inner_screens/feeds_screen.dart';
import 'package:growy/inner_screens/product_details.dart';

import '../inner_screens/on_sale_screen.dart';

class GlobalMethods {
  static navigateToViewAll(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, OnSaleScreen.routeName);
  }

  static navigateToBrowseAll(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, FeedsScreen.routeName);
  }

  static navigateToProductDetails(
      {required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, ProductDetails.routeName);
  }
}
