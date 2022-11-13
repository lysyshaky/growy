import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/providers/dart_theme_provider.dart';
import 'package:growy/services/utils.dart';
import 'package:provider/provider.dart';

class EmptyProductWidget extends StatelessWidget {
  const EmptyProductWidget({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    Color color = Utils(context).color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset('assets/images/box.png'),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _isDark ? Colors.white : Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
