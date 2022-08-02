import 'dart:math';

import 'functions.dart';
import 'number.dart';

extension ListExtension<T> on List<T?> {
  List<T?> slice(int start, [int? end]) {
    return _privateSlice(start, end);
  }

  List<T?> _privateSlice(int start, [int? end, bool inPlace = true]) {
    var length = this.length;
    var untouchedLength = length;
    if (length < 1) {
      return <T>[];
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

    var index = 0;
    try {
      if (inPlace) {
        var reducer = 0;
        // removing left side section
        while (index < untouchedLength - reducer) {
          var pointer = index + start - reducer;
          if (index < pointer) {
            removeAt(0);
            reducer += 1;
          } else {
            break;
          }
        }
        // ignoring right side section
        index = length;
        untouchedLength -= reducer;
        while (index < untouchedLength) {
          removeAt(length);
          index++;
        }
        return this;
      }
    } catch (e) {
      // ignoring catch block
    }
    // eventually we have to make new copy of altered list
    var result = <T?>[];
    while (index < length) {
      result.add(this[index + start]);
      index++;
    }
    return result;
  }

  bool get isGrowable {
    try {
      add(null);
      removeLast();
      return true;
    } catch (e) {
      return false;
    }
  }

  T? removeFirst() {
    return removeAt(0);
  }

  List<T?> drop([int n = 1]) {
    if (n > length) {
      n = length;
    }
    for (var i = 1; i <= n; i++) {
      removeAt(0);
    }
    return this;
  }

  List<T?> dropRight([int n = 1]) {
    if (n > 0) {
      if (n > length) {
        n = length;
      }
      for (var i = 1; i <= n; i++) {
        removeLast();
      }
    }
    return this;
  }

  List<T?> dropRightWhile(bool Function(T? element) test) {
    var index = length - 1;
    while (index >= 0) {
      if (!test(this[index])) {
        break;
      }
      removeLast();
      index--;
    }
    return this;
  }

  List<T?> dropWhile(bool Function(T? element) test) {
    var index = 0;
    while (index < length) {
      if (!test(this[index])) {
        break;
      }
      removeAt(0);
      index++;
    }
    return this;
  }

  List<T?> flatten() {
    var copyList = <Object?>[];
    for (var val in this) {
      if (val is List) {
        for (var innerVal in val) {
          copyList.add(innerVal);
        }
      } else {
        copyList.add(val);
      }
    }
    return copyList as List<T?>;
  }

  List<T?> flattenDepth([int depth = 1]) {
    var copyList = <Object?>[];
    for (var val in this) {
      if (depth > 0 && val != null && val is List) {
        val.flattenDepth(depth - 1).forEach((dynamic element) {
          copyList.add(element);
        });
      } else {
        copyList.add(val);
      }
    }
    return copyList as List<T?>;
  }

  List<T?> flattenDeep() {
    var copyList = <Object?>[];
    forEach((element) {
      if (element != null && element is List) {
        for (var val in element.flattenDeep()) {
          copyList.add(val);
        }
      } else {
        copyList.add(element);
      }
    });
    return copyList as List<T?>;
  }

  List<List<T?>?> chunk([int size = 1]) {
    size = max(size, 0);
    var length = this.length;
    if (length < 1 || size < 1) {
      return <List<T>>[];
    }
    var index = 0;
    var result = <List<T?>?>[];
    while (index < length) {
      result.add(_privateSlice(index, (index += size), false));
    }
    return result;
  }

  List<T?>? compact() {
    removeWhere((element) => isFalsey(element));
    return this;
  }

  List<T?>? addAllWhile(List<T> from, bool Function(T element) test) {
    var index = 0;
    while (index < length) {
      if (!test(from[index])) {
        break;
      }
      add(from[index]);
      index++;
    }
    return this;
  }

  List<T?>? addIf(List<T> from, bool Function(T element) test) {
    var index = 0;
    while (index < length) {
      if (test(from[index])) {
        add(from[index]);
      }
      index++;
    }
    return this;
  }
}
