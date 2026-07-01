import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageView extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String fallbackAsset;

  const NetworkImageView({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackAsset = 'assets/Profile.jpeg',
  });

  @override
  Widget build(BuildContext context) {
    final cleanedUrl = imageUrl.trim();

    if (cleanedUrl.isEmpty) {
      return _buildAssetFallback();
    }

    // 1. Check if the image is a base64 Data URI
    if (cleanedUrl.startsWith('data:image')) {
      try {
        final commaIndex = cleanedUrl.indexOf(',');
        if (commaIndex != -1) {
          final base64Data = cleanedUrl.substring(commaIndex + 1);
          final bytes = base64Decode(base64Data);
          return Image.memory(
            bytes,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _buildAssetFallback(),
          );
        }
      } catch (e) {
        return _buildAssetFallback();
      }
    }

    // 2. Check if the image is a remote URL
    if (cleanedUrl.startsWith('http://') || cleanedUrl.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: cleanedUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Theme.of(context).cardColor,
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildAssetFallback(),
      );
    }

    // 3. Fallback to asset image
    return _buildAssetFallback(assetPath: cleanedUrl);
  }

  Widget _buildAssetFallback({String? assetPath}) {
    final path = assetPath ?? fallbackAsset;
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade900,
        child: const Icon(
          Icons.broken_image_outlined,
          color: Colors.white38,
          size: 28,
        ),
      ),
    );
  }
}
