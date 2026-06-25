import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, String, dynamic)? errorBuilder;
  final ShapeBorder? shape;
  const AppNetworkImage({
    super.key,

    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorWidget: errorBuilder ?? (_, __, ___) => const SizedBox.shrink(),
      imageBuilder: (context, imageProvider) {
        Widget imageWidget = Image(
          image: imageProvider,
          width: width,
          height: height,
          fit: fit,
        );

        if (shape != null) {
          imageWidget = ClipPath(
            clipper: ShapeBorderClipper(shape: shape!),
            child: imageWidget,
          );
        }

        return imageWidget;
      },
    );
  }
}
