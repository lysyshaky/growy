import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/provider/dart_theme_provider.dart';
import 'package:growy/widgets/on_sale_widget.dart';
import 'package:provider/provider.dart';

import '../services/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _offerImages = [
    '/Users/yuralysyshak/growy/assets/images/offres/Offer1.jpg',
    '/Users/yuralysyshak/growy/assets/images/offres/Offer2.jpg',
    '/Users/yuralysyshak/growy/assets/images/offres/Offer3.jpg',
    '/Users/yuralysyshak/growy/assets/images/offres/Offer4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;

    Size size = Utils(context).getScreenSize;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.33,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  _offerImages[index],
                  fit: BoxFit.fill,
                );
              },
              itemCount: _offerImages.length,
              pagination: const SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                    color: Colors.white, activeColor: Colors.green),
              ),
              //contoller buttons for ImagesSlider
              //control: SwiperControl(),
            ),
          ),
          OnSaleWidget(),
        ],
      ),
    );
  }
}
