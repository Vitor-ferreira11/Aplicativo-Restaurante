import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/model/dish.dart';
import 'package:myapp/model/restaurant.dart';
import 'package:myapp/ui/_core/bag_provider.dart';
import 'package:myapp/ui/restaurant/restaurant_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('lista longa permite adicionar e remover prato da sacola', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final bag = BagProvider();
    addTearDown(bag.dispose);
    final dishes = List.generate(
      12,
      (i) => Dish(
        id: '$i',
        name: 'Prato $i',
        description: '',
        price: 25,
        imagePath: 'dishes/default.png',
      ),
    );
    final restaurant = Restaurant(
      id: 'teste',
      imagePath: 'restaurants/monstro-burguer.png',
      name: 'Restaurante teste',
      description: '',
      stars: 4.0,
      distance: 1,
      categories: [],
      dishes: dishes,
    );
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: bag,
        child: MaterialApp(home: RestaurantScreen(restaurant: restaurant)),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Prato 11'));
    await tester.pumpAndSettle();
    final lastTile = find.ancestor(
      of: find.text('Prato 11'),
      matching: find.byType(ListTile),
    );
    await tester.tap(
      find.descendant(of: lastTile, matching: find.byIcon(Icons.add)),
    );
    await tester.pumpAndSettle();
    expect(bag.getMapByAmount()[dishes.last], 1);
    await tester.tap(find.byIcon(Icons.shopping_basket));
    await tester.pumpAndSettle();
    expect(find.text('Sacola'), findsOneWidget);
    expect(find.text('Prato 11'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();
    expect(bag.dishesOnBag, isEmpty);
    expect(find.text('Prato 11'), findsNothing);
  });
}
