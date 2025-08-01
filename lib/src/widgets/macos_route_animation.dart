import 'package:flutter/material.dart';

class MacosRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  MacosRoute({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 550), // Süreyi biraz artırdık
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            // FAZ 1: Merkeze geliş. Animasyonun ilk %60'ı.
            // FAZ 2: Merkezden tam ekrana geçiş. Animasyonun son %40'ı.

            // Büyüme (Scale) animasyonu
            final scaleAnimation = TweenSequence<double>([
              // Faz 1: %40 boyuttan %80 boyuta gel.
              TweenSequenceItem(tween: Tween(begin: 0.4, end: 0.8), weight: 60.0),
              // Faz 2: %80 boyuttan %100 boyuta gel.
              TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 40.0),
            ]).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

            // Belirme (Opacity) animasyonu
            final opacityAnimation = TweenSequence<double>([
              // Faz 1: %10 görünürlükten %50'ye.
              TweenSequenceItem(tween: Tween(begin: 0.1, end: 0.5), weight: 60.0),
              // Faz 2: %50 görünürlükten %100'e.
              TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 40.0),
            ]).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

            // Kayma (Slide) animasyonu
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.0, 0.25), // Ekranın %25 altından başla
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));


            // Animasyon sadece ilk %60'lık dilimde hareket etmeli.
            // Bu yüzden toplam animasyonun %60'ı bittiğinde slide animasyonu bitmiş olur.
            // Bunu daha hassas kontrol etmek için slideAnimation'ı da TweenSequence yapabiliriz.
            // Ama basitlik için şimdilik tek bir eğri ile hareketin başlarda daha hızlı olmasını sağlıyoruz.

            return FadeTransition(
              opacity: opacityAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
        );
}
