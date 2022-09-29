import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/services/utils.dart';
import 'package:growy/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../provider/dart_theme_provider.dart';
import '../widgets/categories_widget.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  List<Color> gridColor = [
    const Color(0xff53b175),
    const Color(0xffF8A44c),
    const Color(0xffF7a593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];
  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': '/Users/yuralysyshak/growy/assets/images/cat/fruits.png',
      'catText': 'Fruits',
    },
    {
      'imgPath': '/Users/yuralysyshak/growy/assets/images/cat/veg.png',
      'catText': 'Vegetables',
    },
    {
      'imgPath': '/Users/yuralysyshak/growy/assets/images/cat/Spinach.png',
      'catText': 'Herbs',
    },
    {
      'imgPath': '/Users/yuralysyshak/growy/assets/images/cat/nuts.png',
      'catText': 'Nuts',
    },
    {
      'imgPath': '/Users/yuralysyshak/growy/assets/images/cat/spices.png',
      'catText': 'Spices',
    },
    {
      'imgPath': '/Users/yuralysyshak/growy/assets/images/cat/grains.png',
      'catText': 'Grains',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final utils = Utils(context);
    Color color = utils.appBarcolor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _isDark ? Colors.black12 : Colors.green,
        centerTitle: true,
        title: TextWidget(
          text: 'Categories',
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240 / 250,
          crossAxisSpacing: 24, //Vertical spacing
          mainAxisSpacing: 24, //Horizotanl spacing
          children: List.generate(6, (index) {
            return CategoriesWidget(
              catText: catInfo[index]['catText'],
              imgPath: catInfo[index]['imgPath'],
              passedColor: gridColor[index],
            );
          }),
        ),
      ),
    );
  }
}
