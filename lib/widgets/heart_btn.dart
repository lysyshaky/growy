import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../services/utils.dart';

class HeartBTN extends StatelessWidget {
  const HeartBTN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;

    return GestureDetector(
      onTap: () {
        print('Heart print: ');
      },
      child: Icon(
        IconlyLight.heart,
        size: 24,
        color: color,
      ),
    );
  }
}
