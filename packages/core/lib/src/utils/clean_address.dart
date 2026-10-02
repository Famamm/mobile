String cleanAddress(String raw) {
  final regex = RegExp(
    r'\b[23456789CFGHJMPQRVWX]{4,8}\+[23456789CFGHJMPQRVWX]{2,3}\b,?\s*',
  );
  return raw.replaceFirst(regex, '').trim();
}