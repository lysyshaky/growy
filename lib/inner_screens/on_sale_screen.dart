import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/widgets/on_sale_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../provider/dart_theme_provider.dart';
import '../services/utils.dart';
import '../widgets/text_widget.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).appBarcolor;
    Size size = Utils(context).getScreenSize;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;

    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(IconlyLight.arrow_left_2, color: color),
          ),
          elevation: 0,
          backgroundColor: _isDark ? Colors.black12 : Colors.green,
          title: TextWidget(
            text: 'Products on sale',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.zero,
          // crossAxisSpacing: 10,
          childAspectRatio: size.width / (size.height * 0.45),
          children: List.generate(16, (index) {
            return const OnSaleWidget();
          }),
        ));
  }
}
