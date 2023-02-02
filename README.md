# Dart Utility

Dart Utility provides operations and functionality to dart.

## Installation

```yaml
# Add into pubspec.yaml
dependencies:
  dart_utility: ^1.0.1
```

```dart
/// Import library (all utils)
import 'package:dart_utility/utility.dart';
```

## Using

### DateTime Util

```dart
import 'package:dart_utility/date.dart';

DateTime today = DateTimeUtil.today;

DateTime endOfToday = DateTimeUtil.endOfToday;

DateTime tomorrow = DateTimeUtil.next(1).startOfDay;

DateTime yesterday = DateTimeUtil.previous(1).startOfDay;

/// Compare DateTimes
assert(yesterday < today);
assert(yesterday < tomorrow);
assert(tomorrow > endOfToday);
assert(today <= endOfToday);

/// To JSON (format "yyyy-MM-ddThh:mm:ss.SSSZ")
String json = today.toJson();
```

### Iterable Util

```dart
import 'package:dart_utility/iterable.dart';

/// Unique by Id
var uniqueProduct = [{'id': 1}, {'id': 2}, {'id': 1}]
    .unique((e) => e['id']);

/// Creates a slice of list from start up to, but not including, end.
var result = [1, 2, 3, 4].slice(2); // => [3, 4]

var result = ['a', 'b', 'c', 'd'].chunk(2); // => [['a', 'b'], ['c', 'd']]

var result = [1, 2, 3].drop(2); // => [3]

var result = [1, 2, 3].dropRight(2); // => [1]

var result = [2, 1, 3, 4, 5].dropRightWhile((element) => element >= 3); // => [2, 1];

var result = [2, 1, 3, 4, 5].dropWhile((element) => element <= 3); // => [4, 5];

var isGrowable = list.isGrowable;
```

### Async Util

```dart
import 'package:dart_utility/async.dart';

var finishState = await store
    .firstWhere((state) => state.type == 'finish' && state.name == 'test')
    .execute(() => store.start('test'));
```
