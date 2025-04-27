import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_image.dart';

class ImageRadio extends StatefulWidget {
  const ImageRadio(
      {super.key,
      required this.image,
      required this.index,
      required this.onPressed,
      required this.selectedIndex});

  final String image;
  final int index;
  final int selectedIndex;
  final Function() onPressed;

  @override
  State<StatefulWidget> createState() => _ImageRadio();
}

class _ImageRadio extends State<ImageRadio> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        side: BorderSide(
            width: (widget.index == widget.selectedIndex) ? 2.0 : 0.5,
            color: (widget.index == widget.selectedIndex)
                ? Color.fromRGBO(38, 79, 33, 1)
                : Color(0x00ffffff)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
          child: CustomNetworkImage(image: widget.image, height: 70, width: 70)),
    );
  }
}
