extension DurationExtensions on Duration {
  String get formatTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits((this).inHours);
    final minutes = twoDigits((this).inMinutes.remainder(60));
    final seconds = twoDigits((this).inSeconds.remainder(60));

    return [if ((this).inHours > 0) hours, minutes, seconds].join(':');
  }
}
