import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/inner_screens/feeds_screen.dart';

import '../services/global_methods.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText})
      : super(key: key);
  final String imagePath, title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.appBarcolor;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              Image.asset(
                imagePath,
                width: double.infinity,
                height: size.height * 0.4,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Whoops!',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 40,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(text: title, color: Colors.cyan, textSize: 20),
              const SizedBox(
                height: 5,
              ),
              TextWidget(text: subtitle, color: Colors.cyan, textSize: 20),
              SizedBox(
                height: size.height * 0.1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                onPressed: () {
                  GlobalMethods.navigateToBrowseAll(
                      ctx: context, routeName: FeedsScreen.routeName);
                },
                child: TextWidget(
                  text: buttonText,
                  textSize: 20,
                  color: Colors.white,
                  isTitle: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
