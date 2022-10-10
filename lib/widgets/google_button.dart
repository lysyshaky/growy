import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/widgets/text_widget.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue.withOpacity(0.7),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Image.asset(
                '/Users/yuralysyshak/growy/assets/images/google.png',
                width: 40.0,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            TextWidget(
              color: Colors.white,
              text: 'Sign in with google',
              textSize: 18,
              isTitle: false,
            )
          ],
        ),
      ),
    );
  }
}
