import 'constants.dart';
import 'iterable.dart';
import 'number.dart';

extension StringExtension on String {
  String slice(int start, [int? end]) {
    var length = this.length;
    if (length <= 0) {
      return '';
    }
    end ??= length;

    if (start < 0) {
      start = -start > length ? 0 : (length + start);
    }
    if (end > length) {
      end = length;
    }
    if (end < 0) {
      end += length;
    }
    length = start > end ? 0 : (end - start).zeroFillRightShift(0);
    start = start.zeroFillRightShift(0);

    var index = -1;
    var result = '';
    while (++index < length) {
      result += this[index + start];
    }
    return result;
  }

  String? get enumVal {
    var list = split('.');
    return list.isEmpty ? null : list.last;
  }

  num? get toNumber {
    if (trim().isEmpty) {
      return null;
    }
    return double.tryParse(trim());
  }

  int count(String value, [bool caseSensitive = true]) {
    if (value.isEmpty) {
      return 0;
    }
    return length - (caseSensitive ? replaceAll(value, '') : toLowerCase().replaceAll(value.toLowerCase(), '')).length;
  }

  bool get isNumber {
    return double.tryParse(this) != null;
  }

  bool get isBinary {
    return reIsBinary.hasMatch(this);
  }

  bool get isDecimal {
    return isNumber;
  }

  bool get isOctal {
    return reIsOctal.hasMatch(this);
  }

  bool get isHex {
    return !reIsBadHex.hasMatch(this);
  }

  String get deburr {
    return replaceAllMapped(reLatin, (match) {
      var value = '', word = match[0] ?? '';
      for (var index = 0; index < word.length; index++) {
        value += deburredLetters[word[index]] ?? word[index];
      }
      return value;
    }).replaceAll(reComboMark, '');
  }

  List<String> get unicodeWords {
    return _unicodeAsciiWords();
  }

  List<String> get asciiWords {
    return _unicodeAsciiWords(false);
  }

  List<String> _unicodeAsciiWords([bool isUnicode = true]) {
    var list = <String>[];
    (isUnicode ? reUnicodeWord : reAsciiWord).allMatches(this).forEach((match) {
      var m = match[0]!;
      if (m.hasUnicodeWord == isUnicode) {
        list.add(m);
      }
    });
    return list;
  }

  bool get hasUnicodeWord {
    return reHasUnicodeWord.hasMatch(this);
  }

  String? get capitalize {
    String? result;
    if (isNotEmpty) {
      result = this[0].toUpperCase();
      if (length > 1) {
        result += substring(1).toLowerCase();
      }
    }
    return result;
  }

  String? get lowerFirst {
    String? result;
    if (isNotEmpty) {
      result = this[0].toLowerCase();
      if (length > 1) {
        result += substring(1);
      }
    }
    return result;
  }

  String get upperFirst {
    var result = '';
    if (isNotEmpty) {
      result = this[0].toUpperCase();
      if (length > 1) {
        result += substring(1);
      }
    }
    return result;
  }

  List<String?> words([RegExp? pattern]) {
    if (pattern == null) {
      var list = <String?>[];
      reUnicodeWord.allMatches(this).forEach((match) {
        list.add(match[0]);
      });
      return list;
    }
    return pattern.allMatches(this).map((match) => '${match[0]}').toList();
  }

  String get camelCase {
    var wordList = words();
    var leftSide = wordList.first!.toLowerCase();
    var rightSide = wordList.skip(1).reduce((value, element) => value! + element!.capitalize!)!;
    return leftSide + rightSide;
  }

  String kebabCase({String separator = '-'}) {
    return _reuseCase(separator);
  }

  String lowerCase({String separator = ' '}) {
    return _reuseCase(separator);
  }

  String snakeCase({String separator = '_'}) {
    return _reuseCase(separator);
  }

  String _reuseCase(String separator) {
    return words().map((word) => word!.toLowerCase()).toList().join(separator);
  }

  String nameCase({String separator = ' '}) {
    return words().map((word) => word!.capitalize).toList().join(separator);
  }

  String repeat([int n = 1]) {
    if (n < 1) {
      return '';
    }
    var result = '', string = this;
    do {
      if ((n % 2) > 0) {
        result += string;
      }
      n = (n / 2).floor();
      if (n > 0) {
        string += string;
      }
    } while (n > 0);
    return result;
  }

  String pad(int length, [String chars = ' ']) {
    var strLength = length != 0 ? this.length : 0;
    if (length == 0 || strLength >= length) {
      return this;
    }
    var mid = (length - strLength) / 2;
    return (_createPadding(mid.floor(), chars) + this + _createPadding(mid.ceil(), chars));
  }

  String _createPadding(int length, String chars) {
    if (chars == '') {
      chars = ' ';
    }
    var charsLength = chars.length;
    if (charsLength < 2) {
      return charsLength > 0 ? chars.repeat(length) : chars;
    }
    var result = chars.repeat((length / chars.length).ceil());
    return chars.hasUnicodeWord ? _castSlice(result._stringToList, 0, length).join('') : result.slice(0, length);
  }

  List<T?> _castSlice<T>(List<T> list, int start, [int? end]) {
    end ??= length;
    return (start == 0 && end >= list.length) ? list : list.slice(start, end);
  }

  List<String> get _stringToList {
    return hasUnicodeWord ? _unicodeToList : _asciiToList;
  }

  List<String> get _asciiToList {
    return split('');
  }

  List<String> get _unicodeToList {
    return reUnicode.allMatches(this).map((match) => match[0].toString()).toList();
  }
}
