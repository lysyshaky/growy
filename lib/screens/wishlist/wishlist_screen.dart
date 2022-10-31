import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:growy/providers/wishlist_provider.dart';
import 'package:growy/screens/wishlist/wishlist_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../inner_screens/product_details.dart';
import '../../provider/dart_theme_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
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
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList =
        wishlistProvider.getWishlistItems.values.toList().reversed.toList();

    return wishlistItemsList.isEmpty
        ? const EmptyScreen(
            buttonText: 'Add a wish',
            title: 'You wishlist is empty',
            subtitle: 'Add to your wishlist something',
            imagePath: '/Users/yuralysyshak/growy/assets/images/wishlist.png')
        : Scaffold(
            appBar: AppBar(
              leading: const BackWidget(),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    onPressed: () async {
                      await GlobalMethods.warningDialog(
                          title: 'Clear wishlist',
                          subtitle: 'Do you wanna clear your wishlist?',
                          fct: () {},
                          context: context);
                    },
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
                text: 'Wishlist(${wishlistItemsList.length})',
                color: color,
                textSize: 24,
                isTitle: true,
              ),
            ),
            body: MasonryGridView.count(
                itemCount: wishlistItemsList.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                      value: wishlistItemsList[index],
                      child: const WishlistWidget());
                }));
  }
  //       ListView.builder(
  //           itemCount: 10,
  //           itemBuilder: (ctx, index) {
  //             return CartWidget();
  //           }));
  // }
}
