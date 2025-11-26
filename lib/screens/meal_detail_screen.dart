import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';

class MealDetailScreen extends StatelessWidget {
  final String mealId;

  const MealDetailScreen({required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4E3),
      appBar: AppBar(
        title: Text('Recipe details', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D6875),
        elevation: 3,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Meal>(
        future: ApiService().fetchMealDetail(mealId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final meal = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Слика со заоблени агли
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.network(meal.image, fit: BoxFit.cover),
                    ),
                  ),
                  // Име на ручекот
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    child: Text(
                      meal.name,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D6875),
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            color: Color(0xFFB5838D).withOpacity(0.2),
                            offset: Offset(1, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Ingredients
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Card(
                      color: Color(0xFFFCD5CE),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14, 14, 14, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ingredients:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Color(0xFFB5838D)),
                            ),
                            ...List.generate(meal.ingredients.length, (i) {
                              return Text(
                                '${meal.measures[i]} ${meal.ingredients[i]}',
                                style: TextStyle(fontSize: 15, color: Colors.black87),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Instructions (How to make)
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Card(
                      color: Color(0xFFEDE7F6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14, 14, 14, 14),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            children: [
                              TextSpan(
                                text: 'How to make:\n',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6D6875)),
                              ),
                              TextSpan(
                                text: meal.instructions,
                                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

