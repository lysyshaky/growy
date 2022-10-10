import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growy/inner_screens/on_sale_screen.dart';
import 'package:growy/inner_screens/product_details.dart';
import 'package:growy/provider/dart_theme_provider.dart';
import 'package:growy/screens/auth/login.dart';
import 'package:growy/screens/btm_bard.dart';
import 'package:growy/screens/home_screen.dart';
import 'package:growy/screens/viewed/viewed_screen.dart';
import 'package:growy/screens/wishlist/wishlist_screen.dart';
import 'package:growy/services/dark_theme_prefs.dart';
import 'package:growy/inner_screens/feeds_screen.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'screens/orders/orders_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isDark = true;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        })
      ],
      child:
          Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: Styles.themeData(themeProvider.getDarkTheme, context),
          home: const LoginScreen(),
          routes: {
            OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
            FeedsScreen.routeName: (ctx) => const FeedsScreen(),
            ProductDetails.routeName: (ctx) => const ProductDetails(),
            WishlistScreen.routeName: (ctx) => const WishlistScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            ViewedScreen.routeName: (ctx) => const ViewedScreen(),
          },
        );
      }),
    );
  }
}
