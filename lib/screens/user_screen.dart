import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/widgets/text_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../provider/dart_theme_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
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
                      text: 'Hi,  ',
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'MyName',
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
                  text: 'yuralysyshak@gmail.com ',
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
                    subtitle: 'Where you live?',
                    icon: IconlyLight.profile,
                    color: color,
                    onPressed: () async {
                      await _showAddressDialog();
                    }),
                _listTiles(
                    title: 'Orders',
                    icon: IconlyLight.wallet,
                    color: color,
                    onPressed: () {}),
                _listTiles(
                    title: 'Wishlist',
                    icon: IconlyLight.heart,
                    color: color,
                    onPressed: () {}),
                _listTiles(
                    title: 'Viewed',
                    icon: IconlyLight.show,
                    color: color,
                    onPressed: () {}),
                _listTiles(
                    title: 'Forget password',
                    icon: IconlyLight.unlock,
                    color: color,
                    onPressed: () {}),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SwitchListTile(
                    title: TextWidget(
                      text:
                          themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
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
                    title: 'Logout',
                    icon: IconlyLight.logout,
                    color: color,
                    onPressed: () async {
                      await _showLogoutDialog();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset('assets/images/warning-sign.png',
                    height: 24, width: 24, fit: BoxFit.fill),
                const SizedBox(
                  width: 8,
                ),
                const Text('Sign out'),
              ],
            ),
            content: const Text('Do you want to Sing out?'),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: TextWidget(
                  color: Colors.green,
                  text: 'Cancel',
                  textSize: 18,
                  isTitle: true,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: TextWidget(
                  color: Colors.red,
                  text: 'Logout',
                  textSize: 18,
                  isTitle: true,
                ),
              ),
            ],
          );
        });
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
                onPressed: () {},
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
