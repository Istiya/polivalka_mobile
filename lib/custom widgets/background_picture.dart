import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgPicture extends StatelessWidget {
  final Alignment _alignment;
  const CustomSvgPicture(this._alignment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _alignment,
      child: SvgPicture.asset(
        'assets/background-$_alignment.svg',
        fit: BoxFit.fill,
      ),
    );
  }

  static List<Widget> backgroundPicture() => [
        CustomSvgPicture(Alignment.topLeft),
        CustomSvgPicture(Alignment.topRight),
        CustomSvgPicture(Alignment.bottomRight),
        CustomSvgPicture(Alignment.bottomLeft),
      ];
}

class BackgroundPicture extends StatelessWidget {
  const BackgroundPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: CustomSvgPicture.backgroundPicture(),
    );
  }
}
