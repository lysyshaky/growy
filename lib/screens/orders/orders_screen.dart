import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/providers/orders_provider.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/dart_theme_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import '../cart/cart_widget.dart';
import 'orders_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//fix issue add couple orders not only one fix click to order and go to product details
class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final utils = Utils(context);
    Color color = utils.color;
    Color appBarcolor = utils.appBarcolor;
    Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;
    return FutureBuilder(
      future: ordersProvider.fetchOrders(),
      builder: (context, snapshot) {
        if (ordersList.isEmpty == true) {
          return EmptyScreen(
              buttonText: AppLocalizations.of(context)!.shop_now_btn,
              title: AppLocalizations.of(context)!.your_order_empty,
              subtitle: AppLocalizations.of(context)!.order_something,
              imagePath: 'assets/images/cart.png');
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: const BackWidget(),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  // child: IconButton(
                  //   onPressed: () async {
                  //     await GlobalMethods.warningDialog(
                  //         title: 'Clear orders',
                  //         subtitle: 'Do you wanna clear your orders?',
                  //         fct: () {
                  //           ordersProvider.clearLocalOrders();
                  //         },
                  //         context: context);
                  //   },
                  //   icon: Icon(
                  //     IconlyLight.delete,
                  //     color: appBarcolor,
                  //   ),
                  // ),
                )
              ],
              elevation: 0,
              backgroundColor: _isDark ? Colors.black12 : Colors.green,
              centerTitle: true,
              title: TextWidget(
                text: AppLocalizations.of(context)!.orders +
                    '(${ordersList.length})',
                color: appBarcolor,
                textSize: 24,
                isTitle: true,
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: ordersList.length,
                    itemBuilder: (ctx, index) {
                      return ChangeNotifierProvider.value(
                          value: ordersList[index],
                          child: const OrdersWidget());
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
      },
    );
  }
}
