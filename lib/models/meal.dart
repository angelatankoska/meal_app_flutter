class Meal {
  final String id;
  final String name;
  final String image;
  final String instructions;
  final List<String> ingredients;
  final List<String> measures;

  Meal({
    required this.id,
    required this.name,
    required this.image,
    required this.instructions,
    required this.ingredients,
    required this.measures,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];
    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? "");
      }
    }

    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      image: json['strMealThumb'],
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }
}
