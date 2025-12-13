import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'package:meal_app/services/favorites_service.dart';


/* class MealCard extends StatelessWidget {
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
} */

class MealCard extends StatefulWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({
    Key? key,
    required this.meal,
    required this.onTap,
  }) : super(key: key);

  @override
  _MealCardState createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  final favService = FavoritesService();
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    favService.isFavorite(widget.meal.id).then((value) {
      setState(() => isFav = value);
    });
  }

  void toggleFavorite() async {
    await favService.toggleFavorite(widget.meal.id);
    setState(() => isFav = !isFav);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 7,
            color: Color(0xFFD5C6E0),
            shadowColor: Color(0xFF6D6875).withOpacity(0.30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(widget.meal.image, height: 100, fit: BoxFit.cover),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    widget.meal.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF563C5C),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ❤️ Favorite button
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () {
                toggleFavorite();
              },
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.redAccent,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
