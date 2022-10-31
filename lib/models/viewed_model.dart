// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ViewedProdModel with ChangeNotifier {
  final String id, productId;

  ViewedProdModel({
    required this.id,
    required this.productId,
  });
}
