// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marker/app/utils/helpers/image_url_util.dart';
import 'package:marker/gen/assets.gen.dart';

class ImageSize {
  ImageSize({
    this.alignment,
    this.dimension,
    this.height,
    this.width,
  });

  final Alignment? alignment;
  final double? dimension;
  final double? height;
  final double? width;

  Widget _makeWidgetCompatible(Widget child) {
    var temp = child;
    if (alignment != null) {
      temp = Align(
        alignment: alignment!,
        child: child,
      );
    }
    if (dimension != null) {
      return SizedBox.square(
        dimension: dimension,
        child: temp,
      );
    }

    if (height != null && width != null) {
      return SizedBox(
        height: height,
        width: width,
        child: temp,
      );
    }

    return temp;
  }
}

extension DecorationX on Decoration {
  Decoration apply(BorderRadius? borderRadius, Color? color, BoxShape? shape) {
    if (this is BoxDecoration) {
      final boxDecoration = this as BoxDecoration;
      return boxDecoration.copyWith(
        borderRadius: boxDecoration.borderRadius ?? borderRadius,
        color: boxDecoration.color ?? color,
        shape: shape ?? boxDecoration.shape,
      );
    }
    return this;
  }
}

const Duration _networkImageTimeout = Duration(seconds: 15);

bool _isBlankImagePath(String? path) => path == null || path.trim().isEmpty;

bool _isValidNetworkUrl(String url) {
  final uri = Uri.tryParse(url);
  return uri != null &&
      uri.hasScheme &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
}

String _fallbackAssetForShape(BoxShape shape) {
  return shape == BoxShape.circle ? Assets.svg.user : Assets.svg.noImage;
}

class ImageView extends StatelessWidget {
  ImageView(
    this.imagePath, {
    super.key,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.color,
    Color? backgroundColor,
    Decoration? decoration,
    this.alignment,
    this.fit = BoxFit.cover,
    this.inner,
    this.outer,
  }) : _decoration = decoration?.apply(borderRadius, backgroundColor, shape) ??
            BoxDecoration(
              shape: shape,
              color: backgroundColor,
              borderRadius: borderRadius,
            );

  final AlignmentGeometry? alignment;

  final BoxFit fit;

  final String imagePath;

  final ImageSize? inner;
  final ImageSize? outer;

  final BorderRadius? borderRadius;

  final BoxShape shape;

  final Color? color;

  final Decoration? _decoration;

  int? _memCacheSize(BuildContext context, double? logicalSize) {
    if (logicalSize == null || logicalSize <= 0 || !logicalSize.isFinite) {
      return null;
    }
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final pixels = logicalSize * ratio;
    if (!pixels.isFinite) return null;
    return pixels.round();
  }

  @override
  Widget build(BuildContext context) {
    if (_isBlankImagePath(imagePath)) {
      return _wrapChild(
        context,
        _FallbackImage(
          assetPath: _fallbackAssetForShape(shape),
          fit: fit,
          color: color,
        ),
      );
    }

    final resolvedPath =
        imagePath.imageType == ImageType.network ? resolveApiMediaUrl(imagePath) : imagePath;
    if (_isBlankImagePath(resolvedPath)) {
      return _wrapChild(
        context,
        _FallbackImage(
          assetPath: _fallbackAssetForShape(shape),
          fit: fit,
          color: color,
        ),
      );
    }

    final type = resolvedPath.imageType;
    final cacheWidth = _memCacheSize(context, inner?.width);
    final cacheHeight = _memCacheSize(context, inner?.height);
    final fallbackAsset = _fallbackAssetForShape(shape);

    final Widget widget = switch (type) {
      ImageType.svg => _SvgIcon(resolvedPath, color: color, fit: fit),
      ImageType.asset => ImageAsset(resolvedPath, color: color, fit: fit),
      ImageType.network => _isValidNetworkUrl(resolvedPath)
          ? _ResilientNetworkImage(
              imageUrl: resolvedPath,
              color: color,
              fit: fit,
              memCacheWidth: cacheWidth,
              memCacheHeight: cacheHeight,
              fallbackAsset: fallbackAsset,
            )
          : _FallbackImage(assetPath: fallbackAsset, fit: fit, color: color),
      ImageType.file => ImageFile(
          resolvedPath,
          color: color,
          fit: fit,
          fallbackAsset: fallbackAsset,
        ),
    };

    return _wrapChild(context, widget);
  }

  Widget _wrapChild(BuildContext context, Widget widget) {
    if (_decoration != null) {
      final decoration = _decoration;

      if ((_decoration is BoxDecoration) && _decoration.borderRadius != null) {
        widget = _checkBoundaries(widget, _decoration.borderRadius);
      } else {
        widget = _checkBoundaries(widget, null);
      }

      widget = inner?._makeWidgetCompatible(widget) ?? widget;

      widget = DecoratedBox(
        decoration: decoration,
        child: widget,
      );
    } else {
      widget = inner?._makeWidgetCompatible(widget) ?? widget;
      widget = _checkBoundaries(widget, borderRadius);
    }

    return outer?._makeWidgetCompatible(widget) ?? widget;
  }

  Widget _checkBoundaries(Widget widget, BorderRadiusGeometry? borderRadius) {
    if (shape == BoxShape.circle) {
      return ClipOval(
        child: widget,
      );
    } else if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: widget);
    }
    return widget;
  }
}

class _FallbackImage extends StatelessWidget {
  const _FallbackImage({
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.color,
  });

  final String assetPath;
  final BoxFit fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (assetPath.endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    }
    return ImageAsset(assetPath, fit: fit, color: color);
  }
}

class _ResilientNetworkImage extends StatefulWidget {
  const _ResilientNetworkImage({
    required this.imageUrl,
    this.color,
    this.fit = BoxFit.cover,
    this.memCacheWidth,
    this.memCacheHeight,
    required this.fallbackAsset,
  });

  final String imageUrl;
  final Color? color;
  final BoxFit fit;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final String fallbackAsset;

  @override
  State<_ResilientNetworkImage> createState() => _ResilientNetworkImageState();
}

class _ResilientNetworkImageState extends State<_ResilientNetworkImage> {
  bool _timedOut = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  @override
  void didUpdateWidget(covariant _ResilientNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _timedOut = false;
      _startTimeout();
    }
  }

  void _startTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(_networkImageTimeout, () {
      if (mounted) {
        setState(() => _timedOut = true);
      }
    });
  }

  void _clearTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
  }

  @override
  void dispose() {
    _clearTimeout();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_timedOut) {
      return _FallbackImage(
        assetPath: widget.fallbackAsset,
        fit: widget.fit,
        color: widget.color,
      );
    }

    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      memCacheWidth: widget.memCacheWidth,
      memCacheHeight: widget.memCacheHeight,
      maxWidthDiskCache: widget.memCacheWidth,
      maxHeightDiskCache: widget.memCacheHeight,
      fit: widget.fit,
      color: widget.color,
      placeholder: (context, url) => const Center(child: AppProgressIndicator()),
      errorWidget: (context, url, error) {
        _clearTimeout();
        return _FallbackImage(
          assetPath: widget.fallbackAsset,
          fit: widget.fit,
          color: widget.color,
        );
      },
      imageBuilder: (context, imageProvider) {
        _clearTimeout();
        return Image(
          image: imageProvider,
          fit: widget.fit,
          color: widget.color,
        );
      },
    );
  }
}

class ImageFile extends Image {
  ImageFile(
    String assetName, {
    super.key,
    super.color,
    super.fit,
    String fallbackAsset = 'assets/svg/no_image.svg',
  }) : super(
          image: FileImage(
            File(assetName),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            double? progress;

            if (loadingProgress.expectedTotalBytes != null) {
              progress = loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!;
              return Center(
                child: AppProgressIndicator(
                  value: progress,
                ),
              );
            }

            return const Center(child: AppProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return _FallbackImage(assetPath: fallbackAsset, fit: fit ?? BoxFit.cover, color: color);
          },
        );
}

class ImageAsset extends Image {
  ImageAsset(
    String assetName, {
    super.key,
    super.color,
    super.fit,
  }) : super(
          image: AssetImage(assetName),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            double? progress;

            if (loadingProgress.expectedTotalBytes != null) {
              progress = loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!;
              return Center(
                child: AppProgressIndicator(
                  value: progress,
                ),
              );
            }

            return const Center(child: AppProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            if (assetName.endsWith('.svg')) {
              return SvgPicture.asset(assetName, fit: fit ?? BoxFit.cover);
            }
            return _FallbackImage(assetPath: Assets.svg.noImage, fit: fit ?? BoxFit.cover, color: color);
          },
        );
}

class AppProgressIndicator extends CircularProgressIndicator {
  const AppProgressIndicator({
    super.key,
    super.value,
    super.strokeCap = StrokeCap.round,
    super.strokeWidth = 2,
  });
}

class _SvgIcon extends SvgPicture {
  _SvgIcon(
    String assetName, {
    AssetBundle? bundle,
    String? package,
    SvgTheme? theme,
    Color? color,
    super.fit,
  }) : super(
          SvgAssetLoader(
            assetName,
            packageName: package,
            assetBundle: bundle,
            theme: theme,
          ),
          colorFilter: color != null
              ? ColorFilter.mode(color, BlendMode.srcIn)
              : null,
        );
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    }
    if (endsWith('.svg')) {
      return ImageType.svg;
    }
    if (startsWith('asset')) {
      return ImageType.asset;
    }
    return ImageType.file;
  }
}

enum ImageType { svg, asset, network, file }
