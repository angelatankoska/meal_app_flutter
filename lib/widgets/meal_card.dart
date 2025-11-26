import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 7,
          color: Color(0xFFD5C6E0),
          shadowColor: Color(0xFF6D6875).withOpacity(0.30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(meal.image, height: 100, fit: BoxFit.cover),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  meal.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF563C5C),
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
