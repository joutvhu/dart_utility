extension IntExtension on int {
  int zeroFillRightShift(int amount) {
    return (this & 0xffffffff) >> amount;
  }
}
