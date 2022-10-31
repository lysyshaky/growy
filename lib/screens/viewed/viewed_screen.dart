import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/screens/viewed/viewed_widget.dart';
import 'package:growy/widgets/empty_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../provider/dart_theme_provider.dart';
import '../../providers/viewed_product_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/text_widget.dart';

class ViewedScreen extends StatefulWidget {
  static const routeName = '/ViewedScreen';
  const ViewedScreen({Key? key}) : super(key: key);

  @override
  State<ViewedScreen> createState() => _ViewedScreenState();
}

class _ViewedScreenState extends State<ViewedScreen> {
  bool check = true;
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final viewedProdItemsList = viewedProdProvider.getViewedProdlistItems.values
        .toList()
        .reversed
        .toList();
    if (viewedProdItemsList.isEmpty) {
      return const EmptyScreen(
        title: 'Your history is empty',
        subtitle: 'No products has been viewed yet!',
        buttonText: 'Shop now',
        imagePath: 'assets/images/history.png',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'Empty your history?',
                    subtitle: 'Are you sure?',
                    fct: () {},
                    context: context);
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),
            )
          ],
          leading: const BackWidget(),
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: TextWidget(
            text: 'History',
            color: color,
            textSize: 24.0,
          ),
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        body: ListView.builder(
            itemCount: viewedProdItemsList.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: ChangeNotifierProvider.value(
                    value: viewedProdItemsList[index], child: ViewedWidget()),
              );
            }),
      );
    }
  }
}
