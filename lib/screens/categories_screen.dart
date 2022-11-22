import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/services/utils.dart';
import 'package:growy/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../providers/dart_theme_provider.dart';
import '../widgets/categories_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final utils = Utils(context);
    Color color = utils.appBarcolor;
    List<Map<String, dynamic>> catInfo = [
      {
        'imgPath': 'assets/images/cat/fruits.png',
        'catText': AppLocalizations.of(context)!.fruits,
        'catName': 'Fruits',
      },
      {
        'imgPath': 'assets/images/cat/veg.png',
        'catText': AppLocalizations.of(context)!.vegetables,
        'catName': 'Vegetables',
      },
      {
        'imgPath': 'assets/images/cat/Spinach.png',
        'catText': AppLocalizations.of(context)!.herbs,
        'catName': 'Herbs',
      },
      {
        'imgPath': 'assets/images/cat/nuts.png',
        'catText': AppLocalizations.of(context)!.nuts,
        'catName': 'Nuts',
      },
      {
        'imgPath': 'assets/images/cat/spices.png',
        'catText': AppLocalizations.of(context)!.spices,
        'catName': 'Spices',
      },
      {
        'imgPath': 'assets/images/cat/grains.png',
        'catText': AppLocalizations.of(context)!.grains,
        'catName': 'Grains',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _isDark ? Colors.black12 : Colors.green,
        centerTitle: true,
        title: TextWidget(
          text: AppLocalizations.of(context)!.categories,
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
              catName: catInfo[index]['catName'],
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
