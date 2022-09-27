import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/widgets/price_widget.dart';
import 'package:growy/widgets/text_widget.dart';

import '../services/utils.dart';
import 'heart_btn.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({Key? key}) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void inistState() {
    _quantityTextController.text = '1';
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
                height: size.width * 0.21,
                width: size.width * 0.2,
                boxFit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Title',
                      color: color,
                      textSize: 20,
                      isTitle: true,
                    ),
                    const HeartBTN(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriceWidget(),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          FittedBox(
                            child: TextWidget(
                              text: 'KG',
                              color: color,
                              textSize: 18,
                              isTitle: true,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                              child: TextFormField(
                            controller: _quantityTextController,
                            key: const ValueKey('10'),
                            style: TextStyle(
                              color: color,
                              fontSize: 18,
                            ),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            enabled: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]')),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              //customize button and all colors in dark theme
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: (() {}),
                  child: TextWidget(
                    text: 'Add to cart',
                    textSize: 20,
                    color: color,
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).cardColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
