import 'package:myapp/model/restaurant.dart';

String normalizeSearch(String value) {
  var result = value.toLowerCase().trim();
  const groups = {
    'a': 'áàâãä',
    'e': 'éèêë',
    'i': 'íìîï',
    'o': 'óòôõö',
    'u': 'úùûü',
    'c': 'ç',
  };
  for (final entry in groups.entries) {
    for (final char in entry.value.split('')) {
      result = result.replaceAll(char, entry.key);
    }
  }
  return result;
}

List<Restaurant> filterRestaurants(
  List<Restaurant> restaurants, {
  String query = '',
  String? category,
}) {
  final term = normalizeSearch(query);
  return restaurants.where((restaurant) {
    final categoryMatches =
        category == null || restaurant.categories.contains(category);
    final searchable = [
      restaurant.name,
      restaurant.description,
      ...restaurant.dishes.map((dish) => dish.name),
    ];
    return categoryMatches &&
        (term.isEmpty ||
            searchable.any((text) => normalizeSearch(text).contains(term)));
  }).toList();
}
