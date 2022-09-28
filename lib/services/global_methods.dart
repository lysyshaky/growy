import 'package:flutter/material.dart';

import '../inner_screens/on_sale_screen.dart';

class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, OnSaleScreen.routeName);
  }
}
