import 'package:flutter/material.dart';

class MacosRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  MacosRoute({required this.child})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) => child,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              // Animasyon için bir "easeOut" eğrisi tanımlıyoruz.
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              );

              // Büyüme (Scale) ve Dikey Kaydırma (Slide) animasyonlarını birleştiriyoruz.
              return ScaleTransition(
                scale: Tween<double>(
                  begin: 0.9, // Animasyon başlangıç ölçeği
                  end: 1.0, // Animasyon bitiş ölçeği
                ).animate(curvedAnimation),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(
                      0.0,
                      0.1,
                    ), // Ekranın %10 altından başlar
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0, // Başlangıçta tamamen saydam
                      end: 1.0, // Bitişte tamamen opak
                    ).animate(curvedAnimation),
                    child: child,
                  ),
                ),
              );
            },
      );
}
