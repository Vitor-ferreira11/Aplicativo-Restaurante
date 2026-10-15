import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/model/dish.dart';
import 'package:myapp/ui/_core/bag_provider.dart';

Dish prato(String id) => Dish(
  id: id,
  name: 'Prato $id',
  description: 'Descrição',
  price: 25,
  imagePath: 'prato.png',
);

void main() {
  late BagProvider bag;
  setUp(() {
    bag = BagProvider();
  });
  tearDown(() {
    bag.dispose();
  });

  test('sacola inicia vazia', () {
    expect(bag.dishesOnBag, isEmpty);
    expect(bag.getMapByAmount(), isEmpty);
  });

  test('agrupa quantidades e remove uma unidade', () {
    final primeiro = prato('1');
    final segundo = prato('2');
    bag.addAllDishes([primeiro, primeiro, segundo]);
    expect(bag.getMapByAmount(), {primeiro: 2, segundo: 1});
    bag.removeDish(primeiro);
    expect(bag.getMapByAmount(), {primeiro: 1, segundo: 1});
    bag.removeDish(primeiro);
    expect(bag.getMapByAmount(), {segundo: 1});
  });

  test('limpa sacola e comunica cada operação aos ouvintes', () {
    var notificacoes = 0;
    bag.addListener(() {
      notificacoes++;
    });
    final item = prato('1');
    bag.addAllDishes([item, item]);
    bag.removeDish(item);
    bag.clearBag();
    expect(notificacoes, 3);
    expect(bag.dishesOnBag, isEmpty);
  });
}
