import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWithLoading extends StatelessWidget {
  final String imageUrl;

  const ImageWithLoading({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CachedNetworkImage(
          imageUrl: imageUrl,
          width: constraints.maxWidth,
          height: 300,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
          fit: BoxFit.cover,
        );
      },
    );
  }
}
