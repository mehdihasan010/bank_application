import 'package:bank_application/presentation/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              Assets.imagesBackground,
              fit: BoxFit.contain,
              //height: screenSize.height * 0.5,
              //width: screenSize.width * 0.5,
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
