import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:growy/screens/wishlist/wishlist_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../inner_screens/product_details.dart';
import '../../provider/dart_theme_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/text_widget.dart';
import '../cart/cart_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final utils = Utils(context);
    Color color = utils.appBarcolor;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  IconlyLight.delete,
                  color: color,
                ),
              ),
            )
          ],
          elevation: 0,
          backgroundColor: _isDark ? Colors.black12 : Colors.green,
          centerTitle: true,
          title: TextWidget(
            text: 'Wishlist',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: MasonryGridView.count(
            crossAxisCount: 2,
            itemBuilder: (context, index) {
              return const WishlistWidget();
            }));
    //       ListView.builder(
    //           itemCount: 10,
    //           itemBuilder: (ctx, index) {
    //             return CartWidget();
    //           }));
    // }
  }
}
