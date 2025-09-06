import 'dart:math';

extension Precision on double {
  double toMyCeil(int fractionDigits) {
    var mod = pow(10, fractionDigits.toDouble()).toDouble();
    return ((this * mod).ceil().toDouble() / mod);
  }

  double toMyFloor(int fractionDigits) {
    var mod = pow(10, fractionDigits.toDouble()).toDouble();
    return ((this * mod).floor().toDouble() / mod);
  }
}
