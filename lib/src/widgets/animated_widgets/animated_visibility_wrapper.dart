import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Animasyon yönünü belirtir.
enum SlideDirection { bottomToTop, topToBottom, leftToRight, rightToLeft }

/// Animasyonun görünürlük durumunda nasıl tetikleneceğini tanımlar.
enum VisibilityAnimationMode { once, repeatOnVisibilityChange, alwaysPlay }

/// Scroll ile görünür olunca fade ve/veya slide animasyonu oynatan widget.
class AnimatedVisibilityWrapper extends StatefulWidget {
  /// İçerik (animasyon uygulanacak çocuk widget).
  final Widget child;

  /// Animasyon süresi.
  final Duration duration;

  /// Animasyon eğrisi.
  final Curve curve;

  /// Kayma (translate) yüzdesi (örneğin: 10 => %10).
  final double offsetPercentage;

  /// Animasyon başlamadan önceki gecikme.
  final Duration delay;

  /// Kayma yönü (slide etkisi için).
  final SlideDirection direction;

  /// Görünürlük değiştiğinde animasyon nasıl davransın?
  final VisibilityAnimationMode mode;

  /// Kayma (translate) efekti aktif mi?
  final bool enableSlide;

  /// Opaklık (fade) efekti aktif mi?
  final bool enableFade;

  /// VisibilityDetector için gerekli olan eşsiz key.
  final Key detectorKey;

  const AnimatedVisibilityWrapper({
    super.key,
    required this.child,
    required this.detectorKey,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.offsetPercentage = 10.0,
    this.delay = Duration.zero,
    this.direction = SlideDirection.rightToLeft,
    this.mode = VisibilityAnimationMode.once,
    this.enableSlide = true,
    this.enableFade = true,
  });

  @override
  State<AnimatedVisibilityWrapper> createState() =>
      _AnimatedVisibilityWrapperState();
}

class _AnimatedVisibilityWrapperState extends State<AnimatedVisibilityWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  bool _hasAnimatedOnce = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    final double offsetValue = widget.offsetPercentage / 100;
    final Offset beginOffset = switch (widget.direction) {
      SlideDirection.bottomToTop => Offset(0, offsetValue),
      SlideDirection.topToBottom => Offset(0, -offsetValue),
      SlideDirection.leftToRight => Offset(-offsetValue, 0),
      SlideDirection.rightToLeft => Offset(offsetValue, 0),
    };

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _triggerAnimation() async {
    if (widget.mode == VisibilityAnimationMode.once && _hasAnimatedOnce) return;
    if (mounted) await Future.delayed(widget.delay);
    if (mounted) _controller.forward();
    _hasAnimatedOnce = true;
  }

  Future<void> _reverseAnimation() async {
    if (widget.mode == VisibilityAnimationMode.repeatOnVisibilityChange) {
      _hasAnimatedOnce = false;
      if (mounted) _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.detectorKey,
      onVisibilityChanged: (info) {
        final isVisible = info.visibleFraction > 0;

        if (isVisible) {
          _triggerAnimation();
        } else {
          _reverseAnimation();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Opacity(
          opacity: widget.enableFade ? _fadeAnimation.value : 1,
          child: Transform.translate(
            offset: widget.enableSlide
                ? _slideAnimation.value * 100
                : Offset.zero,
            child: child,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
