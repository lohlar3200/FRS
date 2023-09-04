import 'package:flutter/foundation.dart';

class BmiProvider extends ChangeNotifier {
  double _bmi = 0.0;

  double get bmi => _bmi;

  set bmi(double value) {
    _bmi = value;
    notifyListeners();
  }

  void updateBmi(double weight, double height) {
    // Calculate the BMI
    double calculatedBmi = weight / (height * height);
    bmi = calculatedBmi;
  }
}