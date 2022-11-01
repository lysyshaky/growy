import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../provider/dart_theme_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import '../cart/cart_widget.dart';
import 'orders_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrdersScreen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final utils = Utils(context);
    Color color = utils.color;
    Color appBarcolor = utils.appBarcolor;
    Size size = Utils(context).getScreenSize;
    bool _isEmpty = true;
    if (_isEmpty == true) {
      return const EmptyScreen(
          buttonText: 'Show now',
          title: 'You didn\'t place any orders',
          subtitle: 'Order something',
          imagePath: 'assets/images/cart.png');
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () async {
                  await GlobalMethods.warningDialog(
                      title: 'Clear orders',
                      subtitle: 'Do you wanna clear your orders?',
                      fct: () {},
                      context: context);
                },
                icon: Icon(
                  IconlyLight.delete,
                  color: appBarcolor,
                ),
              ),
            )
          ],
          elevation: 0,
          backgroundColor: _isDark ? Colors.black12 : Colors.green,
          centerTitle: true,
          title: TextWidget(
            text: 'Orders (2)',
            color: appBarcolor,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: 10,
                itemBuilder: (ctx, index) {
                  return const OrdersWidget();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: color,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
