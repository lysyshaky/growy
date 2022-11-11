import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:growy/consts/consts.dart';
import 'package:growy/consts/firebase_consts.dart';
import 'package:growy/providers/cart_provider.dart';
import 'package:growy/providers/products_provider.dart';
import 'package:growy/providers/wishlist_provider.dart';
import 'package:growy/screens/btm_bar.dart';
import 'package:provider/provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<String> images = Consts.authImagesPaths;
  @override
  void initState() {
    images.shuffle();
    Future.delayed(const Duration(microseconds: 5), () async {
      final productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);
      User? user = authInstance.currentUser;
      if (user == null) {
        await productsProvider.fetchProducts();
        cartProvider.clearLocalCart();
        wishlistProvider.clearLocalWishlist();
      } else {
        await productsProvider.fetchProducts();
        await cartProvider.fetchCart();
        await wishlistProvider.fetchWishlist();
      }
      await productsProvider.fetchProducts();

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const BottomBarScreen(),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Image.asset(
          images[0],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(color: Colors.black.withOpacity(0.7)),
        const Center(
            child: SpinKitSquareCircle(
          color: Colors.green,
        )),
      ],
    ));
  }
}
