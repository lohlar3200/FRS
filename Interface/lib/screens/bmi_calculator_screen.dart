import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../packages/bmi_provider.dart';
import 'barcode_scanner_screen.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  BmiCalculatorScreenState createState() => BmiCalculatorScreenState();
}

class BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  double weight = 0.0;
  double height = 0.0;
  String _inputMessage = ' ';

  // void calculateBMI() {
    // Perform BMI calculation logic here
    // Set isObese based on the calculated BMI

    // Example calculation:
    // double bmi = weight / (height * height);
    // isObese = bmi >= 30;
    // if (kDebugMode) {
    //   print('Weight: $weight');
    //   print('Height: $height');
    //   print('BMI: $bmi');
    //   print('isObese: $isObese');
    // }
    // Navigator.pushNamed(
    //   context,
    //   '/barcodeScanner',
    //   arguments: isObese,
    // );
  // }

  @override
  Widget build(BuildContext context) {
    final bmiProvider = Provider.of<BmiProvider>(context);

    if (bmiProvider.bmi > 0.0) {
      return const BarcodeScannerScreen();
    }

    void calculateBMI(double weight, double height) {
      print("Old BMI: ${bmiProvider.bmi}");
      if (weight == 0.0 || height == 0.0) {
        setState(() {
          _inputMessage = 'Please enter your weight and height.';
        });
        return;
      }
      bmiProvider.updateBmi(weight, height);

      print("New BMI: ${bmiProvider.bmi}");
      // Navigator.pushNamed(context, '/barcodeScanner');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eat-Rite'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'We need some information to determine your obesity status.',
              style: TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40.0),
            Text(
              _inputMessage,
              style: const TextStyle(
                color: Colors.redAccent,
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              onChanged: (value) {
                setState(() {
                  weight = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Height (m)'),
              onChanged: (value) {
                setState(() {
                  height = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                calculateBMI(weight, height);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
