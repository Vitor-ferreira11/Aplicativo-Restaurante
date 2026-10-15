import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/model/dish.dart';
import 'package:myapp/ui/_core/bag_provider.dart';
import 'package:myapp/ui/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('cancelar preserva sacola e confirmar exibe recibo simulado', (
    tester,
  ) async {
    final bag = BagProvider();
    addTearDown(bag.dispose);
    bag.addAllDishes([
      Dish(
        id: '1',
        name: 'Prato teste',
        description: '',
        price: 25,
        imagePath: '',
      ),
    ]);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: bag,
        child: const MaterialApp(home: CheckoutScreen()),
      ),
    );
    await tester.tap(find.text('Finalizar demonstração'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    expect(bag.dishesOnBag.length, 1);
    await tester.tap(find.text('Finalizar demonstração'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar demonstração'));
    await tester.pumpAndSettle();
    expect(find.text('Demonstração concluída'), findsOneWidget);
    expect(find.text('Total simulado: R\$ 25,00'), findsOneWidget);
    expect(bag.dishesOnBag, isEmpty);
    await tester.tap(find.text('Continuar explorando'));
    await tester.pumpAndSettle();
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Finalizar demonstração'),
    );
    expect(button.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });
}
