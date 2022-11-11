import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/screens/auth/forget_pass_screen.dart';
import 'package:growy/screens/auth/login_screen.dart';
import 'package:growy/screens/loading_manager.dart';
import 'package:growy/screens/orders/orders_screen.dart';
import 'package:growy/screens/viewed/viewed_screen.dart';
import 'package:growy/screens/wishlist/wishlist_screen.dart';
import 'package:growy/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../providers/dart_theme_provider.dart';
import '../services/global_methods.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextConroller =
      TextEditingController(text: "");
  @override
  void dispose() {
    // TODO: implement dispose
    _addressTextConroller.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? _address;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });

    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('fullName');
        _address = userDoc.get('shipping-address');

        _addressTextConroller.text = userDoc['shipping-address'];
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(
          subtitle: 'Something went wrong, please try again later',
          context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      // _addressTextConroller.text = value["address"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'Hi, ',
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: _name == null ? "User" : _name,
                              style: TextStyle(
                                  color: color,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('My name is pressed');
                                })
                        ]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: _email == null ? "Email" : _email!,
                    color: color,
                    textSize: 16,
                    isTitle: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 1.5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _listTiles(
                      title: 'Address',
                      subtitle: _address,
                      icon: IconlyLight.profile,
                      color: color,
                      onPressed: () async {
                        await _showAddressDialog();
                      }),
                  _listTiles(
                      title: 'Orders',
                      icon: IconlyLight.wallet,
                      color: color,
                      onPressed: () {
                        GlobalMethods.navigateToOrders(
                            ctx: context, routeName: OrdersScreen.routeName);
                      }),
                  _listTiles(
                      title: 'Wishlist',
                      icon: IconlyLight.heart,
                      color: color,
                      onPressed: () {
                        GlobalMethods.navigateToWishlist(
                            ctx: context, routeName: WishlistScreen.routeName);
                      }),
                  _listTiles(
                      title: 'Viewed',
                      icon: IconlyLight.show,
                      color: color,
                      onPressed: () {
                        GlobalMethods.navigateToViewed(
                            ctx: context, routeName: ViewedScreen.routeName);
                      }),
                  _listTiles(
                      title: 'Forget password',
                      icon: IconlyLight.unlock,
                      color: color,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ForgetPasswordScreen()));
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: SwitchListTile(
                      title: TextWidget(
                        text: themeState.getDarkTheme
                            ? 'Dark mode'
                            : 'Light mode',
                        color: color,
                        textSize: 20,
                        isTitle: true,
                      ),
                      secondary: Icon(themeState.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined),
                      onChanged: (bool value) {
                        setState(() {
                          themeState.setDarkTheme = value;
                        });
                      },
                      value: themeState.getDarkTheme,
                    ),
                  ),
                  _listTiles(
                      title: user == null ? 'Login' : 'Logout',
                      icon:
                          user == null ? IconlyLight.login : IconlyLight.logout,
                      color: color,
                      onPressed: () async {
                        if (user == null) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                          return;
                        }
                        await GlobalMethods.warningDialog(
                            title: 'Sign out',
                            subtitle: 'Do you wanna sign out ?',
                            fct: () async {
                              await authInstance.signOut();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                            },
                            context: context);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Update',
            ),
            content: TextField(
              // onChanged: ((value) {
              //   _addressTextConroller.text;
              // }),
              cursorColor: Colors.green,
              controller: _addressTextConroller,
              decoration: const InputDecoration(hintText: 'Your address'),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    String _uid = user!.uid;
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .update({
                      'shipping-address': _addressTextConroller.text,
                    });
                    Navigator.pop(context);
                    setState(() {
                      _address = _addressTextConroller.text;
                    });
                  } catch (error) {
                    GlobalMethods.errorDialog(
                        subtitle:
                            'Something went wrong, please try again later',
                        context: context);
                  }
                },
                child: TextWidget(
                  color: Colors.green,
                  text: 'Update',
                  textSize: 18,
                  isTitle: true,
                ),
              )
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 20,
        isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle == null ? "" : subtitle,
        color: color,
        textSize: 16,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrow_right_2),
      onTap: () {
        onPressed();
      },
    );
  }
}
