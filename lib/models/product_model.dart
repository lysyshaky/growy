import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String id, title, title_uk, imageUrl, productCategoryName;
  final double price, salePrice;
  final bool isOnSale, isPiece;

  ProductModel(
      {required this.id,
      required this.title,
      required this.title_uk,
      required this.imageUrl,
      required this.productCategoryName,
      required this.price,
      required this.salePrice,
      required this.isOnSale,
      required this.isPiece});
}
