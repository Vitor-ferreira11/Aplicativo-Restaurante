import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/data/restaurant_search.dart';
import 'package:myapp/model/restaurant.dart';
import 'package:myapp/model/dish.dart';

void main() {
  final restaurant = Restaurant(
    id: '1',
    imagePath: '',
    name: 'São João',
    description: 'Comida brasileira',
    stars: 4,
    distance: 1,
    categories: ['Brasileira'],
    dishes: [
      Dish(id: '1', name: 'Feijão', description: '', price: 20, imagePath: ''),
    ],
  );
  test('busca ignora acentos, espaços e caixa e encontra pratos', () {
    expect(filterRestaurants([restaurant], query: ' SAO '), [restaurant]);
    expect(filterRestaurants([restaurant], query: 'feijao'), [restaurant]);
    expect(filterRestaurants([restaurant], query: 'inexistente'), isEmpty);
  });
  test('combina categoria com busca e permite remover filtro', () {
    expect(
      filterRestaurants([restaurant], query: 'joao', category: 'Pizza'),
      isEmpty,
    );
    expect(
      filterRestaurants([restaurant], query: 'joao', category: 'Brasileira'),
      [restaurant],
    );
    expect(filterRestaurants([restaurant]), [restaurant]);
  });
}
