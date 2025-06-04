<!-- @format -->

# Socker

[![pub paketi](https://img.shields.io/pub/v/socker.svg?label=socker&logo=dart)](https://pub.dev/packages/socker) 
[![lisans](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)  

Socker, Flutter uygulamalarınızda `ScaffoldMessenger` ve `Navigator` durumlarına global olarak kolayca erişmenizi sağlayan hafif bir yardımcı pakettir. Böylece, widget ağacının derinliklerinden veya farklı `BuildContext`’lerden bağımsız olarak Snackbar gösterebilir veya sayfalar arası geçiş yapabilirsiniz.

## Özellikler

*   `MaterialApp` için global `scaffoldMessengerKey` sağlar.
*   `MaterialApp` için global `navigatorKey` sağlar. 
*   Flutter projelerine kolay entegrasyon.

## Kurulum

1. Projenizin `pubspec.yaml` dosyasına aşağıdaki bağımlılığı ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  socker: ^0.0.2 # En güncel sürüm için pub.dev adresini kontrol edin
```

2. Terminalde aşağıdaki komutu çalıştırın:

```bash
flutter pub get
```

3. Kullanmak istediğiniz dosyada paketi içe aktarın:

```dart
import 'package:socker/socker.dart';  
```

## Kullanıma Başlama

`MaterialApp` içinde `Socker` sınıfı tarafından sağlanan global anahtarları kullanın:.

```dart
import 'package:flutter/material.dart';
import 'package:socker/socker.dart'; // Socker paketini import edin

// main.dart dosyanız
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Socker tarafından sağlanan global anahtarları MaterialApp'e atayın
      scaffoldMessengerKey: Socker.scafKey, // Bu satırı ekleyin
      navigatorKey: Socker.navKey,         // Bu satırı ekleyin
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// context ile tema bilgisi alın
      /// context olmadan `Socker.isDark` kullanılabilir
      /// renk kullanirken ana yontem olarak sunu tercih edin:
      /// `backgroundColor: context.backgroundColor` bu yontem tema durumuna gore renk atayacaktir
      backgroundColor: context.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Socker Demo Ana Sayfa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TypewriterText(text: 'Bu metin daktilo tipi bir animasyon ile yazdirilacaktir'),
            20.height,
            ElevatedButton(
              onPressed: () {
                Socker.snackBar(title:  'Merhaba Socker!');
              },
              child: const Text('SnackBar Göster'),
            ),
            /// `const SizedBox(height: 20)` yerine kullanilabilir kisa yontem:
            20.height,
            ElevatedButton(
              onPressed: () {
                /// Socker kullanarak yeni bir sayfaya gitme
                /// no context method: `Socker.go(const DetailPage())`
                context.go(const DetailPage());
              },
              child: const Text('Detay Sayfasına Git'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detay Sayfası'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bu detay sayfasıdır.'),
            32.height,
            TextButton(
              child: const Text('Sayfayi Kapat'),
              onPressed: context.back,
            ),
          ]
        ),
      ),
    );
  }
}
```

add pubspec.yaml
```yaml
flutter:
  assets:
    assets/vectors/
    assets/images/
    assets/fonts/
``` 

## Neler var?
1. ColorExtensions
```dart
  // String objeden Color objesine donustur
  // 6 veya 8 karakter 00FF1122
  String hex = '#FF1122'; // veya `#` olmadan
  Color color = hexStr.toColor();

  // Color objesini String degere donustur
  String hexStr = color.colorToHex();
```

2. ContextExtensions
```dart
  // Yeni widgeta yonlendir
  // Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: (context) => const DetailPage(),
  //   ),
  // )

  // yerine:
  context.go(const DetailPage());
  
  // onceki sayfalari yok etmek icin pushAndRemoveUntil yerine:
  context.goReset(const DetailPage());
  
  // bir onceki sayfaya donmek icin
  context.back();

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;
  double get safeHeight => height - (viewInsets.bottom + viewPadding.top);

  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  bool get isMobile => width < 768;
  bool get isDesktop => width > 1200;
  bool get isTablet => !isMobile && !isDesktop;

  double get containerWidth => isDesktop ? 1024 : width;
  double get defaultContainerPadding => isDesktop ? 0 : 12;
  double get defaultPadding => 12;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  Brightness get brightness => theme.brightness;

  bool get isDark => brightness == Brightness.dark;
  bool get isLight => !isDark;
```

3. DurationExtensions
```dart
// Duration bilgisini 12:14 olarak String degere donusturmak icin:
var kalanSure = Duration(minutes: 30);
var kalanSureStr = kalanSure.formatTime; // Örn: "30:00"
```

4. NumExtensions
```dart
// Buyuk sayilari kisalmak icin
var binliSayi = 172369;
var milyonluSayi = 1720369;

var kisaBinli = binliSayi.countShorter();
var kisaMilyonlu = milyonluSayi.countShorter();

// kisaBinli cikti: 172 bin
// kisaMilyonlu cikti: 1.7 ml



// const SizedBox(height: 20) yerine:
20.height;
20.width; 
```

5. StringExtensions
```dart
bool isEmail = 'aildev@outlook.com'.isEmail; // true
bool isEmail = 'adw@.c'.isEmail; // false
```

6. WidgetExtensions
```dart
Container().expanded(), // widgeti expanded ile sar
Image.asset('path').size(w: 200, h:100), // widgeta boyut ata

// paddingler
Image.asset('path').padAll(12),
Image.asset('path').padHor(12),  // Yatay bosluk
Image.asset('path').padVer(12),  // Dikey bosluk
Image.asset('path').padOnly(l: 12, t: 12, r: 12, b: 12), 

Container().opac(.4) // Opacity 0 ile 1 arasinda double deger

Image.asset('path').radius(16), // kenarlari yuvarla
Image.asset('path').radiusVert(t: 16, b: 8), // dikey kenarlari yuvarla
Image.asset('path').radiusHor(l: 16, r: 8), // yatay kenarlari yuvarla

// Widgeta scroll ozelligi ver
Column(
  children: [
    ...
  ]
).scrolling(),

Text('selam').center, // Widgeti ortala

// Widgeti pozisyonla
Container().alignTR, // ust sag
Container().alignTL, // ust sol
Container().alignBR, // alt sag
Container().alignBL, // alt sol
Container().alignC, // ortala
Container().alignCL, // orta sag
Container().alignCT, // orta ust
Container().alignCR, // orta sol
Container().alignBL, // orta alt
```

7. AnimatedVisibilityWrapper
  - Ekranda belirdiği anda animasyon yapar
  - Kayar, silikleşir, büyür… hepsi bir arada
  - Yönünü sen seç: yukarıdan, aşağıdan, soldan, sağdan
  - Gecikmeli mi başlasın? Süresi ne kadar olsun? Hepsi sende
  - Her defasında mı oynasın, sadece ilk sahnede mi? Tercih senin
  
```dart
AnimatedVisibilityWrapper(child: Text('Animasyonlu'));
```
[Daha fazla bilgi](https://tlogum.web.app/#content/3739NG46aP13xg96f3zc)

8. TapScaleWrapper
Dokunulduğunda widget'ı kucultup normal boyutuna gerı dondurerek dokunma animasyonu gosterir.

```dart
TapScaleWrapper(child: Icon(Icons.favorite));
```

## Ek Bilgiler
Paketle ilgili sorularınız, önerileriniz veya geri bildirimleriniz için [aildev@outlook.com](mailto:aildev@outlook.com) adresinden iletişime geçebilirsiniz. 

## Katkıda Bulunma 
Katkılarınızı memnuniyetle karşılıyoruz! Lütfen bir pull request açmadan önce, yapmak istediğiniz değişiklikleri tartışmak için bir issue oluşturun. 

## Lisans 
Bu proje MIT Lisansı altında lisanslanmıştır.