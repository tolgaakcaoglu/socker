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
