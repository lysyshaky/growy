import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/screens/viewed/viewed_widget.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../provider/dart_theme_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/text_widget.dart';

class ViewedScreen extends StatelessWidget {
  static const routeName = '/ViewedScreen';
  const ViewedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final utils = Utils(context);
    Color color = utils.color;
    Color appBarcolor = utils.appBarcolor;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () async {
                  await GlobalMethods.warningDialog(
                      title: 'Clear history',
                      subtitle: 'Do you wanna clear your history?',
                      fct: () {},
                      context: context);
                },
                icon: Icon(
                  IconlyLight.delete,
                  color: appBarcolor,
                ),
              ),
            )
          ],
          elevation: 0,
          backgroundColor: _isDark ? Colors.black12 : Colors.green,
          centerTitle: true,
          title: TextWidget(
            text: 'History',
            color: appBarcolor,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const ViewedWidget();
            },
          ),
        ));
  }
}
