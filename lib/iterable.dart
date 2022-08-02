import 'dart:math';

import 'functions.dart';
import 'number.dart';

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> unique<R>([R Function(T e)? keyGetter]) {
    Set<dynamic> keys = {};
    dynamic Function(T e) getKey = keyGetter ?? (T e) => e;
    return where((element) {
      var key = getKey(element);
      if (keys.contains(key)) {
        return false;
      } else {
        keys.add(key);
        return true;
      }
    });
  }

  Iterable<T> between(int start, int end) {
    if (start < 0) {
      start = 0;
    }
    int length = start > end ? 0 : (end - start).zeroFillRightShift(0);
    start = start.zeroFillRightShift(0);
    return skip(start).take(length);
  }

  Iterable<R?> flatten<R>() {
    return expand((element) {
      if (element is Iterable) {
        return element.cast();
      } else {
        return [element].cast();
      }
    });
  }

  Iterable<R?> flattenDepth<R>([int depth = 1]) {
    return expand((element) {
      if (element is Iterable && depth > 0) {
        return element.flattenDepth(depth - 1).cast();
      } else {
        return [element].cast();
      }
    });
  }

  Iterable<R?> flattenDeep<R>() {
    return expand((element) {
      if (element is Iterable) {
        return element.flattenDeep().cast();
      } else {
        return [element].cast();
      }
    });
  }
}

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
