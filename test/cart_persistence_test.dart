import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/data/cart_storage.dart';
import 'package:myapp/model/dish.dart';
import 'package:myapp/ui/_core/bag_provider.dart';

class MemoryStorage implements CartStorage {
  String? value;
  bool fail = false;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String data) async {
    if (fail) throw StateError('Storage unavailable');
    value = data;
  }
}

Dish dish(int price) => Dish(
  id: '1',
  name: 'Prato',
  description: '',
  price: price,
  imagePath: 'dishes/default.png',
);

void main() {
  test('restaura quantidades usando preço atual e persiste limpeza', () async {
    final storage = MemoryStorage();
    final first = BagProvider(storage: storage);
    first.addAllDishes([dish(20), dish(20)]);
    await first.whenSaved;
    final restored = BagProvider(storage: storage);
    await restored.restore([dish(25)]);
    expect(restored.dishesOnBag.length, 2);
    expect(restored.totalInCents, 5000);
    restored.clearBag();
    await restored.whenSaved;
    final empty = BagProvider(storage: storage);
    await empty.restore([dish(25)]);
    expect(empty.dishesOnBag, isEmpty);
    first.dispose();
    restored.dispose();
    empty.dispose();
  });

  test('dados inválidos e falha de gravação preservam uso na sessão', () async {
    final storage = MemoryStorage()..value = '{invalid';
    final bag = BagProvider(storage: storage);
    await bag.restore([dish(20)]);
    expect(bag.storageError, isNotNull);
    storage.fail = true;
    bag.addAllDishes([dish(20)]);
    await bag.whenSaved;
    expect(bag.totalInCents, 2000);
    expect(bag.storageError, isNotNull);
    storage.fail = false;
    bag.removeDish(dish(20));
    await bag.whenSaved;
    expect(bag.storageError, isNull);
    expect(bag.dishesOnBag, isEmpty);
    bag.dispose();
  });

  test('ignora pratos desconhecidos e quantidades fora do limite', () async {
    final storage =
        MemoryStorage()..value = '{"version":1,"items":{"1":100,"unknown":2}}';
    final bag = BagProvider(storage: storage);
    await bag.restore([dish(20)]);
    expect(bag.dishesOnBag, isEmpty);
    bag.addAllDishes(List.generate(110, (_) => dish(20)));
    expect(bag.dishesOnBag.length, 99);
    await bag.whenSaved;
    bag.dispose();
  });
}
