import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socker/src/extensions/context_extensions.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Ekranda metni yazılıyormuş gibi gösteren bir yazı efekti.
/// ChatGPT veya komut satırı benzeri efektler için uygundur.
class TypewriterText extends StatefulWidget {
  /// Yazdırılacak tam metin.
  final String text;

  /// Metin için kullanılacak stil (yazı tipi, boyut, renk vs).
  final TextStyle? textStyle;

  /// Her karakterin yazılma süresi (varsayılan: 50ms).
  final Duration duration;

  /// Yanıp sönen dikey çizgi (cursor) gösterilsin mi?
  final bool showCursor;

  /// Metnin tamamı yazıldığında çalışacak callback fonksiyonu.
  final VoidCallback? onComplete;

  const TypewriterText({
    super.key,

    /// Zorunlu: Gösterilecek metin.
    required this.text,

    /// İsteğe bağlı: Metin stilini özelleştirmek için.
    this.textStyle,

    /// İsteğe bağlı: Karakter başına yazma süresi.
    this.duration = const Duration(milliseconds: 50),

    /// İsteğe bağlı: Yanıp sönen imleç gösterilsin mi?
    this.showCursor = true,

    /// İsteğe bağlı: Yazı tamamlandığında yapılacak işlem.
    this.onComplete,
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

  @override
  void initState() {
    super.initState();
  }

  void _startTyping() {
    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(widget.duration, (_) {
      if (_index < widget.text.length) {
        setState(() {
          _visibleText += widget.text[_index];
          _index++;
        });
      } else {
        _typingTimer?.cancel();
        if (!_completed) {
          _completed = true;
          _showCursorNow = false;
          widget.onComplete?.call();
        }
      }
    });
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
      key: GlobalKey(),
      onVisibilityChanged: (info) {
        final isVisible = info.visibleFraction > 0;
        if (isVisible) {
          _startTyping();

          if (widget.showCursor) {
            _cursorBlinkTimer = Timer.periodic(
              const Duration(milliseconds: 500),
              (_) {
                setState(() => _showCursorNow = !_showCursorNow);
              },
            );
          }
        } else {
          _typingTimer?.cancel();
          if (_completed) {
            _visibleText = '';
            _completed = false;
            _showCursorNow = false;
            widget.onComplete?.call();
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
            if (widget.showCursor && _index < widget.text.length)
              TextSpan(
                text: _showCursorNow ? "|" : " ",
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
