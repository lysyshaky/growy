import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/consts/consts.dart';
import 'package:growy/providers/locale_provider.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/dart_theme_provider.dart';
import '../providers/products_provider.dart';
import '../services/utils.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_product_widget.dart';
import '../widgets/feed_items.dart';
import '../widgets/text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/CategoryScreen";
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProductSearch = [];
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).appBarcolor;
    Size size = Utils(context).getScreenSize;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final productsProvider = Provider.of<ProductsProvider>(context);
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    final languageProvider = Provider.of<LocaleProvider>(context);
    final locale = languageProvider.locale;
    List<ProductModel> productByCat = productsProvider.findByCategory(catName);
    return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0,
          backgroundColor: _isDark ? Colors.black12 : Colors.green,
          centerTitle: true,
          title: TextWidget(
            text: locale.languageCode == "en"
                ? "$catName"
                : "Продукти" ?? catName,
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: productByCat.isEmpty
            ? EmptyProductWidget(
                text: AppLocalizations.of(context)!.no_products_by_category,
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: kBottomNavigationBarHeight,
                        //fix positions of icons and hintText
                        child: TextField(
                          focusNode: _searchTextFocusNode,
                          controller: _searchTextController,
                          onChanged: (valuee) {
                            setState(() {
                              listProductSearch = productsProvider
                                  .searchQuery(_searchTextController!.text);
                            });
                          },
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 1),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 24,
                                color: Colors.green,
                              ),
                              hintText: AppLocalizations.of(context)!.what_mind,
                              suffixIcon: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _searchTextController!.clear();
                                  _searchTextFocusNode.unfocus();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: _searchTextFocusNode.hasFocus
                                      ? Colors.red
                                      : _isDark
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              )),
                        ),
                      ),
                    ),
                    _searchTextController!.text.isNotEmpty &&
                            listProductSearch.isEmpty
                        ? EmptyProductWidget(
                            text: AppLocalizations.of(context)!.no_products,
                          )
                        : GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            padding: EdgeInsets.zero,
                            // crossAxisSpacing: 10,
                            childAspectRatio: size.width / (size.height * 0.65),
                            children: List.generate(
                                _searchTextController!.text.isNotEmpty
                                    ? listProductSearch.length
                                    : productByCat.length, (index) {
                              return ChangeNotifierProvider.value(
                                  value: _searchTextController!.text.isNotEmpty
                                      ? listProductSearch[index]
                                      : productByCat[index],
                                  child: const FeedsWidget());
                            }),
                          ),
                  ],
                ),
              ));
  }
}
