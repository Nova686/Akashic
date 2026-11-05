import 'dart:ui';

import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class ZoomGalleryImage {
  const ZoomGalleryImage({required this.heroTag, required this.image, this.caption, this.badge, this.aspectRatio, this.placeholder});

  final Object heroTag;
  final ImageProvider? image;
  final String? caption;
  final String? badge;
  final double? aspectRatio;
  final String? placeholder;
}

Future<void> showZoomGallery(
  BuildContext context, {
  required List<ZoomGalleryImage> images,
  required int initialIndex,
  List<Widget> Function(BuildContext context, int index)? actionsOf,
  bool showsPosition = true,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (routeContext, animation, secondaryAnimation) =>
          _ZoomGalleryPage(images: images, initialIndex: initialIndex, animation: animation, actionsOf: actionsOf, showsPosition: showsPosition),
    ),
  );
}

class _ZoomGalleryPage extends StatefulWidget {
  const _ZoomGalleryPage({required this.images, required this.initialIndex, required this.animation, required this.showsPosition, this.actionsOf});

  final List<ZoomGalleryImage> images;
  final int initialIndex;
  final Animation<double> animation;
  final List<Widget> Function(BuildContext context, int index)? actionsOf;
  final bool showsPosition;

  @override
  State<_ZoomGalleryPage> createState() => _ZoomGalleryPageState();
}

class _ZoomGalleryPageState extends State<_ZoomGalleryPage> {
  static const double viewportFraction = 0.8;

  late final PageController _pages = PageController(initialPage: widget.initialIndex, viewportFraction: viewportFraction);
  late int _current = widget.initialIndex;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).maybePop();

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: widget.animation, curve: Curves.easeOutCubic);
    final image = widget.images[_current];
    return Stack(
      children: [
        Positioned.fill(
          child: Semantics(
            button: true,
            label: MaterialLocalizations.of(context).closeButtonTooltip,
            onTap: _close,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
              child: AnimatedBuilder(
                animation: curve,
                builder: (context, _) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16 * curve.value, sigmaY: 16 * curve.value),
                  child: ColoredBox(color: AkashicColors.night.withValues(alpha: 0.55 * curve.value)),
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.62,
                child: PageView.builder(
                  controller: _pages,
                  itemCount: widget.images.length,
                  onPageChanged: (page) => setState(() => _current = page),
                  itemBuilder: (context, index) => AnimatedBuilder(
                    animation: _pages,
                    builder: (context, child) {
                      final page = _pages.hasClients && _pages.position.haveDimensions ? _pages.page ?? _current.toDouble() : widget.initialIndex.toDouble();
                      final distance = (page - index).abs().clamp(0.0, 1.0);
                      return Transform.scale(
                        scale: 1 - 0.14 * distance,
                        child: Opacity(opacity: 1 - 0.45 * distance, child: child),
                      );
                    },
                    child: _ZoomedImage(image: widget.images[index]),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FadeTransition(
                opacity: curve,
                child: Column(
                  children: [
                    if (image.caption case final caption?)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          caption,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AkashicTypography.body(size: 16, weight: FontWeight.w800),
                        ),
                      ),
                    if (widget.showsPosition && widget.images.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${_current + 1} / ${widget.images.length}', style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                      ),
                    if (widget.actionsOf case final actionsOf?)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: actionsOf(context, _current)),
                      ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ZoomedImage extends StatelessWidget {
  const _ZoomedImage({required this.image});

  final ZoomGalleryImage image;

  @override
  Widget build(BuildContext context) {
    final provider = image.image;
    final placeholder = ColoredBox(
      color: AkashicColors.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(image.placeholder ?? image.caption ?? '', textAlign: TextAlign.center, style: AkashicTypography.displayTitle(size: 22)),
        ),
      ),
    );
    final picture = ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: provider == null ? placeholder : Image(image: provider, fit: BoxFit.contain, semanticLabel: image.caption ?? image.placeholder, errorBuilder: (context, error, stack) => placeholder),
    );
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Hero(
          tag: image.heroTag,
          child: Stack(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: AkashicColors.lavender.withValues(alpha: 0.35), blurRadius: 36, spreadRadius: -6),
                    const BoxShadow(color: Color(0x99000000), blurRadius: 24, offset: Offset(0, 14)),
                  ],
                ),
                child: image.aspectRatio == null ? picture : AspectRatio(aspectRatio: image.aspectRatio!, child: picture),
              ),
              if (image.badge case final badge?)
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AkashicColors.night.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                    child: Text(badge, style: AkashicTypography.numeral(size: 16).copyWith(color: AkashicColors.lavender)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
