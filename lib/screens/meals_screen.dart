import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import '../widgets/search_bar.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;
  MealsScreen({required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late Future<List<Meal>> mealsFuture;
  TextEditingController searchController = TextEditingController();
  List<Meal> filteredMeals = [];

  @override
  void initState() {
    mealsFuture = ApiService().fetchMealsByCategory(widget.category);
    super.initState();
  }

  void filterMeals(String query, List<Meal> meals) {
    setState(() {
      filteredMeals = meals
          .where((meal) => meal.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE7F6),
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Color(0xFF6D6875),
        elevation: 3,
      ),
      body: FutureBuilder<List<Meal>>(
          future: mealsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Meal> mealsToShow = searchController.text.isEmpty
                  ? snapshot.data!
                  : filteredMeals;

              return Column(
                children: [
                  SearchBarWidget(
                    controller: searchController,
                    onChanged: (query) => filterMeals(query, snapshot.data!),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: mealsToShow.length,
                        itemBuilder: (context, index) {
                          final meal = mealsToShow[index];
                          return MealCard(
                            meal: meal,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MealDetailScreen(mealId: meal.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}


