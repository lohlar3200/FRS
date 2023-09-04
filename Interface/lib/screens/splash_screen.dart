import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.lightBlueAccent, Colors.blue])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 70.0, bottom: 20.0),
              child: const Text(
                "Eat-Rite",
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10.0, 0.00, 10.0, 0.0),
              child: Image.asset(
                "assets/images/burger_bg_rmvd.png",
                cacheWidth: 300,
                cacheHeight: 300,
              ),
              // child: const Icon(Icons.food_bank, color: Colors.white, size: 130.0,),
            ),
            Container(
              // color: Colors.orange,
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: const Text(
                'Get advice and suggestions on your next packaged food',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                margin: const EdgeInsets.only(top: 40.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/bmiCalculator');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    // fixedSize: const Size(150.0, 50.0),
                  ),
                  child: const Text(
                      "Get Advice",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0
                      )
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}