# Utility

Utility for Dart

## Installation

```yaml
# Add into pubspec.yaml
dependencies:
  utility: ^1.0.0
```

## Using

### DateTime Util

```dart
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
/// Unique by Id
var uniqueProduct = productSource
    .unique((e) => e.id);
```

### Async Util

```dart
var finishState = await store
    .firstWhere((state) => state.type == 'finish' && state.name == 'test')
    .execute(() => store.start('test'));
```