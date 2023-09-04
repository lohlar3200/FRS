import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../packages/bmi_provider.dart';

class FoodDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> response;

  const FoodDetailsScreen(this.response, {Key? key}) : super(key: key);

  @override
  FoodDetailsScreenState createState() => FoodDetailsScreenState();
}

class FoodDetailsScreenState extends State<FoodDetailsScreen> {
  bool showSuggestedFood = false;
  bool showMainFoodPrep = false;
  bool showSimilarFoodPrep = false;
  bool showMainRecipeInstructions = false;
  bool showNearestRecipeInstructions = false;
  bool showSimilarRecipeInstructions = false;

  @override
  Widget build(BuildContext context) {
    final foodData = widget.response['food_data'];
    final nearestRecipe = widget.response['nearest_recipe'];
    final similarFood = widget.response['similar_food_with_less_calories'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 6,
              margin: EdgeInsetsGeometry.lerp(const EdgeInsets.all(2.0), const EdgeInsets.all(10.0), 0.5)!,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 300, // Adjust the height as needed
                        child: PageView.builder(
                          itemCount: foodData['Images'].length,
                          itemBuilder: (context, index) {
                            final imageUrl = foodData['Images'][index];
                            return Center(
                              child: Image.network(
                                imageUrl,
                                errorBuilder: (context, exception, stackTrace) {
                                  return Image.asset("assets/images/resolve-images-not-showing-problem-1.webp");
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          '${foodData['Images'].length} Images',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          foodData['Name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Preparation Time: ${foodData['PrepTime']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Food Content:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text('Calories: ${foodData['foodContents']['Calories']}'),
                        Text('Carbohydrates: ${foodData['foodContents']['CarbohydrateContent']}'),
                        Text('Cholesterol: ${foodData['foodContents']['CholesterolContent']}'),
                        Text('Fat: ${foodData['foodContents']['FatContent']}'),
                        Text('Fiber: ${foodData['foodContents']['FiberContent']}'),
                        Text('Protein: ${foodData['foodContents']['ProteinContent']}'),
                        Text('Saturated Fat: ${foodData['foodContents']['SaturatedFatContent']}'),
                        Text('Sodium: ${foodData['foodContents']['SodiumContent']}'),
                        Text('Sugar: ${foodData['foodContents']['SugarContent']}'),
                        SizedBox(height: 10),
                        if (!showMainRecipeInstructions) Padding(
                          padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showMainRecipeInstructions = true;
                              });
                            },
                            child: const Text('Show Cooking Instructions'),
                          ),
                        ),
                        if (showMainRecipeInstructions) Padding(
                          padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showMainRecipeInstructions = false;
                                  });
                              },
                              child: const Text('Hide Cooking Instructions'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Recipe Instructions:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (similarFood != null && similarFood['RecipeInstructions'] is List<dynamic>)
                              Column(
                                children: [
                                  for (var instruction in similarFood['RecipeInstructions'])
                                    if (instruction is String)
                                      Text(instruction),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            if (similarFood != null || nearestRecipe != null) ...[
              if (!showSuggestedFood || !showSimilarFoodPrep) Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showSuggestedFood = true;
                      showSimilarFoodPrep = true;
                    });
                  },
                  child: const Text('View Suggestions'),
                ),
              ),
              if (showSuggestedFood && showSimilarFoodPrep) Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showSuggestedFood = false;
                      showSimilarFoodPrep = false;
                    });
                  },
                  child: const Text('Close Suggestions'),
                ),
              ),
              const SizedBox(height: 10),
              if (showSuggestedFood) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    'Suggested Food',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  elevation: 6,
                  margin: EdgeInsetsGeometry.lerp(const EdgeInsets.all(2.0), const EdgeInsets.all(10.0), 0.5)!,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            height: 300, // Adjust the height as needed
                            child: PageView.builder(
                              itemCount: similarFood['Images'].length,
                              itemBuilder: (context, index) {
                                final imageUrl = similarFood['Images'][index];
                                return Center(
                                  child: Image.network(
                                    imageUrl,
                                    errorBuilder: (context, exception, stackTrace) {
                                      return Image.asset("assets/images/resolve-images-not-showing-problem-1.webp");
                                    }
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            // margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              '${similarFood['Images'].length} Images',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              similarFood['Name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Preparation Time: ${similarFood['PrepTime']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Food Content:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Calories: ${similarFood['foodContents']['Calories']}'),
                            Text('Carbohydrates: ${similarFood['foodContents']['CarbohydrateContent']}'),
                            Text('Cholesterol: ${similarFood['foodContents']['CholesterolContent']}'),
                            Text('Fat: ${similarFood['foodContents']['FatContent']}'),
                            Text('Fiber: ${similarFood['foodContents']['FiberContent']}'),
                            Text('Protein: ${similarFood['foodContents']['ProteinContent']}'),
                            Text('Saturated Fat: ${similarFood['foodContents']['SaturatedFatContent']}'),
                            Text('Sodium: ${similarFood['foodContents']['SodiumContent']}'),
                            Text('Sugar: ${similarFood['foodContents']['SugarContent']}'),
                            const SizedBox(height: 10),
                            if (!showSimilarRecipeInstructions) Padding(
                              padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showSimilarRecipeInstructions = true;
                                  });
                                },
                                child: const Text('Show Cooking Instructions'),
                              ),
                            ),
                            if (showSimilarRecipeInstructions)
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            showSimilarRecipeInstructions = false;
                                          });
                                        },
                                        child: const Text('Hide Cooking Instructions'),
                                      ),
                                      SizedBox(height: 10),
                                      const Text(
                                        'Recipe Instructions:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (similarFood != null && similarFood['RecipeInstructions'] is List<dynamic>)
                                        Column(
                                            children: [
                                              for (var instruction in similarFood['RecipeInstructions'])
                                                if (instruction is String)
                                                  Text(instruction),
                                            ]
                                        )
                                    ]
                                )
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 15),
              if (showSimilarFoodPrep) ...[
                Card(
                  elevation: 6,
                  margin: EdgeInsetsGeometry.lerp(const EdgeInsets.all(2.0), const EdgeInsets.all(10.0), 0.5)!,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            height: 300, // Adjust the height as needed
                            child: PageView.builder(
                              itemCount: nearestRecipe['Images'].length,
                              itemBuilder: (context, index) {
                                final imageUrl = nearestRecipe['Images'][index];
                                return Center(
                                  child: Image.network(
                                      imageUrl,
                                      errorBuilder: (context, exception, stackTrace) {
                                        return Image.asset("assets/images/resolve-images-not-showing-problem-1.webp");
                                      }
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              '${nearestRecipe['Images'].length} Images',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              similarFood['Name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Preparation Time: ${nearestRecipe['PrepTime']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Food Content:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Calories: ${nearestRecipe['foodContents']['Calories']}'),
                            Text('Carbohydrates: ${nearestRecipe['foodContents']['CarbohydrateContent']}'),
                            Text('Cholesterol: ${nearestRecipe['foodContents']['CholesterolContent']}'),
                            Text('Fat: ${nearestRecipe['foodContents']['FatContent']}'),
                            Text('Fiber: ${nearestRecipe['foodContents']['FiberContent']}'),
                            Text('Protein: ${nearestRecipe['foodContents']['ProteinContent']}'),
                            Text('Saturated Fat: ${nearestRecipe['foodContents']['SaturatedFatContent']}'),
                            Text('Sodium: ${nearestRecipe['foodContents']['SodiumContent']}'),
                            Text('Sugar: ${nearestRecipe['foodContents']['SugarContent']}'),
                            const SizedBox(height: 10),
                            if (!showNearestRecipeInstructions) Padding(
                              padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showNearestRecipeInstructions = true;
                                  });
                                },
                                child: const Text('Show Cooking Instructions'),
                              ),
                            ),
                            if (showNearestRecipeInstructions) Padding(
                              padding: const EdgeInsets.only(left: 0.0, right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        showNearestRecipeInstructions = false;
                                      });
                                    },
                                    child: const Text('Hide Cooking Instructions'),
                                  ),
                                  SizedBox(height: 10),
                                  const Text(
                                    'Recipe Instructions:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (nearestRecipe != null && nearestRecipe['RecipeInstructions'] is List<dynamic>)
                                    Column(
                                      children: [
                                        for (var instruction in nearestRecipe['RecipeInstructions'])
                                          if (instruction is String)
                                            Text(instruction),
                                      ]
                                    )
                                ]
                              )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ],
        ),
      ),
    );
  }
}