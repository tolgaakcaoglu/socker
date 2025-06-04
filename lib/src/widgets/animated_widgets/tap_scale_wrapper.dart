import 'package:flutter/material.dart';

class TapScaleWrapper extends StatefulWidget {
  /// Küçültme animasyonunun uygulanacağı widget.
  final Widget child;

  /// Widget'a dokunulduğunda tetiklenecek geri çağrı fonksiyonu.
  final VoidCallback? onTap;

  /// Küçültme ve normale dönme animasyonunun süresi.
  /// Varsayılan olarak 150 milisaniyedir.
  final Duration duration;

  /// Dokunulduğunda widget'ın ne kadar küçüleceğini belirten faktör.
  /// Örneğin, 0.75 değeri widget'ın %75 boyutuna küçüleceği anlamına gelir.
  /// Varsayılan olarak 0.75'tir.
  final double scaleFactor;

  const TapScaleWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 150),
    this.scaleFactor = 0.75,
    // Dokunulduğunda ne kadar küçüleceği (örn: 0.95 = %95 boyut)
  });

  @override
  State<TapScaleWrapper> createState() => _TapScaleWrapperState();
}

class _TapScaleWrapperState extends State<TapScaleWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: widget.scaleFactor, // En düşük ölçek değeri
      upperBound: 1.0, // Normal ölçek değeri
    );
    // Başlangıçta tam boyutta olması için controller'ın değerini upperBound'a ayarla
    _controller.value = 1.0;

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Animasyon eğrisi
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    // Animasyonu tersine (küçülme yönünde) başlat
    _controller.reverse();
  }

  void _handleTapUp(TapUpDetails details) {
    // Animasyonu ileriye (normal boyuta dönme yönünde) başlat
    _controller.forward();
    // Eğer bir onTap fonksiyonu verilmişse çağır
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    // Dokunma iptal edilirse animasyonu normale döndür
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      // `onTap` callback'i zaten `_handleTapUp` içinde çağrılıyor.
      // İsterseniz GestureDetector'ın kendi `onTap`'ını da kullanabilirsiniz
      // ama bu durumda `widget.onTap`'ı iki kez çağırmamaya dikkat edin.
      child: ScaleTransition(
        scale: _animation, // Ölçek animasyonunu uygula
        child: widget.child,
      ),
    );
  }
}
