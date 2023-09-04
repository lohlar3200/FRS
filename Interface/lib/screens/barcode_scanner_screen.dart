import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../packages/bmi_provider.dart';
import 'food_details_screen.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}

class BarcodeScannerScreenState extends State<BarcodeScannerScreen> {

  String scannedBarcode = 'Scan a barcode';
  String userStatus = ' ';
  String manualBarcode = ' ';
  bool isLoading = false;
  String userBmiStr = ' ';

  Future<void> scanBarcode() async {
    try {
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
            '#FF0000', // Color for the scan button
            'Cancel', // Text for the cancel button
            false, // Whether to show the flash icon
            ScanMode.DEFAULT, // Scan mode (other modes available)
      );

      if (barcodeResult != '-1') {
        await fetchFoodInformation(barcodeResult);
      } else {
        // Handle error cases, show an error message
            showDialog(
                context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to scan barcode. Please try again or enter barcode manually.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      setState(() {
        scannedBarcode = 'Scan Failed';
      });
    }
  }

  Future<void> fetchFoodInformation(String barcodeResult) async {
    setState(() {
      isLoading = true;
    });

    try {
      // final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      //       barcodeResult,
      //       language: OpenFoodFactsLanguage.ENGLISH,
      //       fields: [ProductField.ALL],
      //       version: ProductQueryVersion.v3,
      //     );

      // final ProductResultV3 result =
      //     await OpenFoodAPIClient.getProductV3(configuration);

      const ipAddress = '159.65.27.138';
      // const ipAddress = '192.168.100.11';
      final url = 'http://$ipAddress:8000/food-recommendation?barcode=$barcodeResult&bmi=$userBmiStr';
      print("Fetching food information from: $url");
      final result = await http.get(Uri.parse(url));
      print("Result: $result");
      print(jsonDecode(result.statusCode.toString()));
      if (result.statusCode == 200) {
        final response = jsonDecode(result.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailsScreen(
                response!
            ),
          ),
        );
      }
      else {
        // Handle case when product information is not available
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('No information available for this barcode.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      // if (result.status == 'success') {
      //       final foodName = result.product?.productName;
      //       final nutritionalValues = result.product?.nutriments?.toJson();
      //       final ingredients = result.product?.ingredients;
      //       // print(ingredients?.map((e) => e.toJson().values));
      //
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => FoodDetailsScreen(
      //               foodName!,
      //               nutritionalValues!
      //           ),
      //         ),
      //       );
      //     }

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Fluttertoast.showToast(msg: 'Failed to fetch food information.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bmiProvider = Provider.of<BmiProvider>(context);
    double userBmi = bmiProvider.bmi;
    userBmiStr = userBmi.toStringAsFixed(0);

    if (userBmi < 18.5) {
      userStatus = 'Underweight';
    }
    else if (userBmi >= 18.5 && userBmi < 25) {
      userStatus = 'Normal Weight';
    }
    else if (userBmi >= 25 && userBmi < 30) {
      userStatus = 'Overweight';
    }
    else if (userBmi >= 30) {
      userStatus = 'Obese';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("You are $userStatus"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) const CircularProgressIndicator(),
              Text(
                scannedBarcode,
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: scanBarcode,
                child: const Text('Scan Barcode'),
              ),
              const SizedBox(height: 16.0),
              const Text("Or"),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Enter barcode'),
                        content: TextField(
                          onChanged: (value) {
                            setState(() {
                              manualBarcode = value;
                            });
                          }
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              fetchFoodInformation(manualBarcode);
                            },
                            child: Text('OK'),
                          )
                        ]
                      )
                  );
                },
                child: const Text("Enter barcode manually"),
              )
            ],
          ),
        ),
      ),
    );
  }
}