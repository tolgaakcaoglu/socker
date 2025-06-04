import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socker/src/extensions/context_extensions.dart';
import 'package:socker/src/models/enums.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration duration;
  final bool showCursor;
  final VoidCallback? onComplete;
  final VisibilityAnimationMode mode;
  final ValueKey hero;

  const TypewriterText({
    super.key,
    required this.text,
    this.textStyle,
    this.duration = const Duration(milliseconds: 100),
    this.showCursor = true,
    this.onComplete,
    required this.hero,
    this.mode = VisibilityAnimationMode.once,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _visibleText = "";
  int _index = 0;
  Timer? _typingTimer;
  Timer? _cursorBlinkTimer;
  bool _showCursorNow = true;
  bool _completed = false;
  bool _hasAnimatedOnce = false;

  void _startTyping() {
    if (widget.mode == VisibilityAnimationMode.once && _hasAnimatedOnce) return;

    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(widget.duration, (_) {
      if (_index < widget.text.length) {
        setState(() {
          _visibleText += widget.text[_index];
          _index++;
        });
      } else {
        _typingTimer?.cancel();
        _typingTimer = null;
        if (!_completed) {
          _hasAnimatedOnce = true;
          _completed = true;
          widget.onComplete?.call();
        }
      }
    });

    if (widget.showCursor) {
      _cursorBlinkTimer?.cancel(); // Önceki varsa iptal et
      _cursorBlinkTimer = Timer.periodic(const Duration(milliseconds: 350), (
        _,
      ) {
        if (mounted) {
          setState(() => _showCursorNow = !_showCursorNow);
        }
      });
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorBlinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.hero,
      onVisibilityChanged: (info) {
        final isVisible = info.visibleFraction > 0;

        if (isVisible && _typingTimer == null && !_completed) {
          _startTyping();
        } else if (!isVisible) {
          if (widget.mode == VisibilityAnimationMode.repeatOnVisibilityChange) {
            _typingTimer?.cancel();
            _cursorBlinkTimer?.cancel();
            _typingTimer = null;
            _cursorBlinkTimer = null;
            _index = 0;
            _hasAnimatedOnce = false;
            _showCursorNow = false;
            _visibleText = '';
            _completed = false;
            if (mounted) setState(() {});
          }
        }
      },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: _visibleText,
              style: widget.textStyle ?? const TextStyle(fontSize: 18),
            ),
            if (widget.showCursor && !_completed)
              TextSpan(
                text: _showCursorNow ? "|" : "",
                style:
                    widget.textStyle?.copyWith(color: context.primaryColor) ??
                    TextStyle(fontSize: 18, color: context.primaryColor),
              ),
          ],
        ),
      ),
    );
  }
}
