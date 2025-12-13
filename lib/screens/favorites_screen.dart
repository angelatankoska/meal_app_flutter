import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final favService = FavoritesService();
  final api = ApiService();

  List<String> favoriteIds = [];
  List<Meal> favoriteMeals = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    favoriteIds = await favService.getFavorites();

    List<Meal> temp = [];
    for (String id in favoriteIds) {
      Meal meal = await api.fetchMealDetail(id);
      temp.add(meal);
    }

    setState(() {
      favoriteMeals = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Recipes"),
        backgroundColor: Color(0xFF6D6875),
      ),
      body: favoriteMeals.isEmpty
          ? Center(child: Text("No favorites yet"))
          : GridView.builder(
        padding: EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: favoriteMeals.length,
        itemBuilder: (context, index) {
          final meal = favoriteMeals[index];
          return MealCard(
            meal: meal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(mealId: meal.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
