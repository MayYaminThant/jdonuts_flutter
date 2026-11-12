import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.loading = false});
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: Palette.cyan, shape: const StadiumBorder()),
          onPressed: loading ? null : onPressed,
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text(
                  text.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      );
}

class DonutImage extends StatelessWidget {
  const DonutImage({
    super.key,
    this.size = 130,
    required this.image,
    required this.imageUrl,
    this.fit,
  });
  final String image; //will remove later
  final String imageUrl;
  final double size;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    var placeholder = Image.asset('assets/images/$image',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.bakery_dining));
    return CachedNetworkImage(
        imageUrl: imageUrl,
        width: 95,
        height: 95,
        fit: fit ?? BoxFit.contain,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder);
  }
}
