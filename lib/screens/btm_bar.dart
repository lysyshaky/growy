import 'package:badges/badges.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:badges/badges.dart' as prefix;
import 'package:flutter/material.dart';
import 'package:growy/providers/dart_theme_provider.dart';
import 'package:growy/screens/categories_screen.dart';
import 'package:growy/screens/home_screen.dart';
import 'package:growy/screens/user_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/cart_provider.dart';
import 'cart/cart_screen.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home'},
    {'page': CategoriesScreen(), 'title': 'Categories'},
    {'page': const CartScreen(), 'title': 'Cart'},
    {'page': const UserScreen(), 'title': ''},
  ];

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;

    return Scaffold(
      //App bar for all screens
      // appBar: AppBar(
      //   backgroundColor: _isDark ? Colors.black12 : Colors.green,
      //   title: Text(
      //     _pages[_selectedIndex]['title'],
      //     style: TextStyle(
      //         color: _isDark ? Colors.green : Colors.white,
      //         fontSize: 24,
      //         fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.green,
        unselectedItemColor: _isDark ? Colors.green : Colors.green.shade100,
        selectedItemColor: _isDark ? Colors.green : Colors.white,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: _isDark ? Colors.black12 : Colors.green,
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            backgroundColor: _isDark ? Colors.black12 : Colors.green,
            icon: Icon(_selectedIndex == 1
                ? IconlyBold.category
                : IconlyLight.category),
            label: AppLocalizations.of(context)!.categories,
          ),
          BottomNavigationBarItem(
            backgroundColor: _isDark ? Colors.black12 : Colors.green,
            icon: Consumer<CartProvider>(builder: (_, myCart, ch) {
              return prefix.Badge(
                  toAnimate: true,
                  shape: BadgeShape.circle,
                  badgeColor: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(
                    myCart.getCartItems.length.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Icon(
                      _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy));
            }),
            label: AppLocalizations.of(context)!.cart,
          ),
          BottomNavigationBarItem(
            backgroundColor: _isDark ? Colors.black12 : Colors.green,
            icon: Icon(
                _selectedIndex == 3 ? IconlyBold.user_2 : IconlyLight.user),
            label: AppLocalizations.of(context)!.user,
          ),
        ],
      ),
    );
  }
}
