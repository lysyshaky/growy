import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/consts/consts.dart';
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

class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedsScreenState";
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
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
  void initState() {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    productsProvider.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).appBarcolor;
    Size size = Utils(context).getScreenSize;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProducts;
    return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0,
          backgroundColor: _isDark ? Colors.black12 : Colors.green,
          centerTitle: true,
          title: TextWidget(
            text: 'All products',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: SingleChildScrollView(
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
                        listProductSearch =
                            productsProvider.searchQuery(valuee);
                      });
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.green, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.green, width: 1),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 24,
                          color: Colors.green,
                        ),
                        hintText: "What's in your mind",
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
                      text: 'No products found, please try another keyword!')
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
                              : allProducts.length, (index) {
                        return ChangeNotifierProvider.value(
                            value: _searchTextController!.text.isNotEmpty
                                ? listProductSearch[index]
                                : allProducts[index],
                            child: const FeedsWidget());
                      }),
                    ),
            ],
          ),
        ));
  }
}
