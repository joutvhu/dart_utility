bool isFalsey(dynamic value) {
  return value == null ||
      (value is bool && value == false) ||
      (value is String && value.trim() == '') ||
      (value is num && value == 0);
}

bool isNumber(dynamic s) {
  if (s is num) {
    return true;
  }
  if (s is String) {
    return double.tryParse(s.trim()) != null;
  }
  return false;
}

num? toNumber(dynamic value, {bool showException = false}) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value;
  }
  if (value is! String) {
    if (showException) {
      throw Exception('Only String and num allowed.');
    }
    return null;
  }
  return double.tryParse(value.toString().trim());
}
