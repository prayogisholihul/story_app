extension StringExtension on String {
  String get cleanedMessage {
    final colonIndex = indexOf(':');
    return colonIndex != -1 ? substring(colonIndex + 2).trim() : this;
  }
}