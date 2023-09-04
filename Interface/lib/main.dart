import 'package:eat_rite/packages/bmi_provider.dart';
import 'package:eat_rite/screens/barcode_scanner_screen.dart';
import 'package:eat_rite/screens/bmi_calculator_screen.dart';
import 'package:eat_rite/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() =>
    runApp(
        ChangeNotifierProvider(
          create: (BuildContext context) => BmiProvider(),
          child: const EatRiteApp(),
        )
    );

class EatRiteApp extends StatelessWidget {
  const EatRiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat-Rite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/bmiCalculator': (context) => const BmiCalculatorScreen(),
        '/barcodeScanner': (context) => const BarcodeScannerScreen(),
      },
    );
  }
}