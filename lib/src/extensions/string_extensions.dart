extension StringExtensions on String {
  /// String'in geçerli bir e-posta adresi olup olmadığını kontrol eder.
  bool get isEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// String'in geçerli bir e-posta adresi olmadığını kontrol eder.
  bool get isNotEmail {
    return !isEmail;
  }

  /// String'in geçerli bir URL olup olmadığını kontrol eder.
  bool get isUrl => RegExp(
    r'^(https?:\/\/)?' // http:// veya https:// (isteğe bağlı)
    r'([\w\-]+\.)+' // alan adı (örneğin, www.google.)
    r'[a-zA-Z]{2,}', // üst düzey alan adı (örneğin, com)
  ).hasMatch(this);

  /// Bu string'i dosya adı olarak kullanan bir SVG dosyasının varlık yolunu döndürür.
  /// SVG'nin 'assets/vectors/' dizininde bulunduğu varsayılır.
  String get svgAsset {
    return 'assets/vectors/$this.svg';
  }

  bool isValidTrPhoneNumber() {
    // Sayılardan başka karakterleri temizle
    String digits = replaceAll(RegExp(r'[^0-9]'), '');

    // +90 ile başlıyorsa 90'ı kaldır
    if (digits.startsWith('90') && digits.length > 10) {
      digits = digits.substring(2);
    }

    // 0 ile başlıyorsa başındaki 0'ı kaldır
    if (digits.startsWith('0') && digits.length > 10) {
      digits = digits.substring(1);
    }

    // Şimdi sadece 10 haneli numara kaldı
    if (digits.length != 10) return false;

    // Türkiye mobil kodları (5 ile başlar)
    final validMobilePrefixes = [
      '501',
      '502',
      '503',
      '504',
      '505',
      '506',
      '507',
      '508',
      '509',
      '530',
      '531',
      '532',
      '533',
      '534',
      '535',
      '536',
      '537',
      '538',
      '539',
      '540',
      '541',
      '542',
      '543',
      '544',
      '545',
      '546',
      '547',
      '548',
      '549',
      '550',
      '551',
      '552',
      '553',
      '554',
      '555',
      '556',
      '557',
      '558',
      '559',
      '560',
      '561',
      '562',
      '563',
      '564',
      '565',
      '566',
      '567',
      '568',
      '569',
      '570',
      '571',
      '572',
      '573',
      '574',
      '575',
      '576',
      '577',
      '578',
      '579',
      '580',
      '581',
      '582',
      '583',
      '584',
      '585',
      '586',
      '587',
      '588',
      '589',
      '590',
      '591',
      '592',
      '593',
      '594',
      '595',
      '596',
      '597',
      '598',
      '599',
    ];

    final prefix = digits.substring(0, 3);

    // Sadece geçerli prefix kabul
    if (!validMobilePrefixes.contains(prefix)) return false;

    // Geri kalan 7 hane rakam olmalı
    final remaining = digits.substring(3);
    if (!RegExp(r'^\d{7}$').hasMatch(remaining)) return false;

    return true;
  }

  /// Bu string'i dosya adı olarak kullanan bir resim dosyasının varlık yolunu döndürür.
  /// Resmin 'assets/images/' dizininde bulunduğu varsayılır.
  String get imgAsset {
    return 'assets/images/$this';
  }

  /// String'in ilk harfini büyük harfe çevirir.
  /// Orijinal string boşsa boş bir string döndürür.
  String capitalize() {
    if (isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// String'i başlık durumuna dönüştürür (örneğin, "merhaba dünya" "Merhaba Dünya" olur).
  String toTitleCase() {
    return split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  /// CamelCase veya boşluklu string'i snake_case yapar.
  /// Örneğin, "merhabaDunya" veya "Merhaba Dunya" "merhaba_dunya" olur.
  String toSnakeCase() {
    final regExp = RegExp(r'(?<=[a-z])[A-Z]');
    return replaceAllMapped(
      regExp,
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).toLowerCase().replaceAll(' ', '_');
  }

  /// String'in başka bir string'i (büyük/küçük harf duyarsız) içerip içermediğini kontrol eder.
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }

  /// String'in yalnızca sayısal karakterlerden oluşup oluşmadığını kontrol eder.
  bool get isNumeric => RegExp(r'^\d+$').hasMatch(this);

  /// String'i belirtilen [maxLength]'e kısaltır ve string'in uzunluğu [maxLength]'i aşarsa
  /// sonuna üç nokta ("...") ekler.
  /// Uzunluğu [maxLength]'ten küçük veya eşitse orijinal string'i döndürür.
  String truncateWithEllipsis(int maxLength) {
    return (length <= maxLength) ? this : '${substring(0, maxLength)}...';
  }
}
