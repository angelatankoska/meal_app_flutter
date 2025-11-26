import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import '../widgets/search_bar.dart';
import '../models/category.dart';
import 'meals_screen.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>> categoriesFuture;
  TextEditingController searchController = TextEditingController();
  List<Category> filteredCategories = [];

  @override
  void initState() {
    categoriesFuture = ApiService().fetchCategories();
    super.initState();
  }

  void filterCategories(String query, List<Category> categories) {
    setState(() {
      filteredCategories = categories
          .where((cat) => cat.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8EDEB),
      appBar: AppBar(
        title: Text("Categories"),
        backgroundColor: Color(0xFFB5838D),
        elevation: 3,
        actions: [
          IconButton(
            icon: Icon(Icons.casino, color: Colors.white),
            onPressed: () async {
              final randomMeal = await ApiService().fetchRandomMeal();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealDetailScreen(mealId: randomMeal.id),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Category> categoriesToShow = searchController.text.isEmpty
                ? snapshot.data!
                : filteredCategories;

            return Column(
              children: [
                SearchBarWidget(
                  controller: searchController,
                  onChanged: (query) => filterCategories(query, snapshot.data!),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.80,
                      ),
                      itemCount: categoriesToShow.length,
                      itemBuilder: (context, index) {
                        final cat = categoriesToShow[index];
                        return CategoryCard(
                          category: cat,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealsScreen(category: cat.name),
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
        },
      ),
    );
  }
}
