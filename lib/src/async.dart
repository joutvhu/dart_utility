extension SteamExtension<T> on Stream<T> {
  Stream<T> execute(void Function() executor) {
    executor();
    return this;
  }
}

extension FutureExtension<T> on Future<T> {
  Future<T> execute(void Function() executor) {
    executor();
    return this;
  }
}
