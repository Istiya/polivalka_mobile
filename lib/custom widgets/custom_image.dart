import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage(
      {super.key,
      required this.image,
      required this.height,
      required this.width});

  final String image;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return image.contains(RegExp('[.]svg\$'))
        ? SizedBox(
            height: height,
            width: width,
            child: SvgPicture.network(
              image,
              fit: BoxFit.cover,
            ))
        : SizedBox(
            height: height,
            width: width,
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
            ),
          );
  }
}
