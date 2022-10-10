import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/widgets/text_widget.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {Key? key,
      required this.ftc,
      required this.buttonText,
      required this.primary})
      : super(key: key);
  final Function ftc;
  final String buttonText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: primary,
        ),
        onPressed: () {
          ftc();
        },
        child: TextWidget(
          color: Colors.white,
          text: buttonText,
          textSize: 18,
          isTitle: false,
        ),
      ),
    );
  }
}
