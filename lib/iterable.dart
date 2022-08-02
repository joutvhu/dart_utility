extension IterableExtension<E> on Iterable<E> {
  Iterable<E> unique<T>([T Function(E e)? keyGetter]) {
    Set<dynamic> keys = {};
    dynamic Function(E e) getKey = keyGetter ?? (E e) => e;
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
}
