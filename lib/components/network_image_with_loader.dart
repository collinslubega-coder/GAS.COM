import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWithLoader extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final BoxFit fit;

  const NetworkImageWithLoader(
    this.imageUrl, {
    super.key,
    this.radius = 12.0,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = imageUrl.startsWith('http');

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: isNetworkImage
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
            )
          : Image.asset(
              imageUrl,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error));
              },
            ),
    );
  }
}