import 'package:flutter/material.dart';
import 'dart:async';

class ChangingText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration duration;

  const ChangingText({
    super.key,
    required this.texts,
    this.duration = const Duration(seconds: 2),
    this.style,
  });

  @override
  State<ChangingText> createState() => _ChangingTextState();
}

class _ChangingTextState extends State<ChangingText> {
  int _index = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (_) {
      _index = (_index + 1) % widget.texts.length;
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          // Fade animasyonu
          final fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          // Slide animasyonu
          final offsetAnimation =
              Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );

          return ClipRect(
            child: FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(position: offsetAnimation, child: child),
            ),
          );
        },
        child: Text(
          widget.texts[_index],
          key: ValueKey<int>(_index),
          style: widget.style,
        ),
      ),
    );
  }
}
