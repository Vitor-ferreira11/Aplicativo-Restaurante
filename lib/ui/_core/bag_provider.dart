import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:myapp/data/cart_storage.dart';
import 'package:myapp/model/dish.dart';

class BagProvider extends ChangeNotifier {
  BagProvider({CartStorage? storage}) : _storage = storage;
  final CartStorage? _storage;
  final List<Dish> _dishes = [];
  Future<void> _pending = Future.value();
  bool _disposed = false;
  String? storageError;

  List<Dish> get dishesOnBag => List.unmodifiable(_dishes);
  int get totalInCents =>
      _dishes.fold(0, (sum, dish) => sum + dish.price * 100);
  Future<void> get whenSaved => _pending;

  Future<void> restore(Iterable<Dish> catalog) async {
    if (_storage == null) return;
    try {
      final value = await _storage.read();
      if (value == null) return;
      final decoded = jsonDecode(value);
      if (decoded is! Map ||
          decoded['version'] != 1 ||
          decoded['items'] is! Map) {
        throw const FormatException('Sacola inválida');
      }
      final available = {for (final dish in catalog) dish.id: dish};
      final restored = <Dish>[];
      for (final entry in (decoded['items'] as Map).entries) {
        final quantity = entry.value;
        final dish = available[entry.key];
        if (dish != null && quantity is int && quantity > 0 && quantity <= 99) {
          restored.addAll(List.filled(quantity, dish));
        }
      }
      _dishes
        ..clear()
        ..addAll(restored);
      notifyListeners();
    } catch (_) {
      storageError =
          'Não foi possível recuperar a sacola salva. Você pode continuar nesta sessão.';
    }
  }

  void addAllDishes(List<Dish> dishes) {
    for (final dish in dishes) {
      if (_dishes.where((item) => item.id == dish.id).length < 99) {
        _dishes.add(dish);
      }
    }
    _changed();
  }

  void removeDish(Dish dish) {
    final index = _dishes.indexWhere((item) => item.id == dish.id);
    if (index < 0) return;
    _dishes.removeAt(index);
    _changed();
  }

  void clearBag() {
    _dishes.clear();
    _changed();
  }

  Map<Dish, int> getMapByAmount() {
    final firstById = <String, Dish>{};
    final result = <Dish, int>{};
    for (final dish in _dishes) {
      final item = firstById.putIfAbsent(dish.id, () => dish);
      result[item] = (result[item] ?? 0) + 1;
    }
    return result;
  }

  void _changed() {
    final storage = _storage;
    if (storage != null) {
      final value = jsonEncode({
        'version': 1,
        'items': {
          for (final entry in getMapByAmount().entries)
            entry.key.id: entry.value,
        },
      });
      _pending = _pending.then((_) async {
        try {
          await storage.write(value);
          storageError = null;
        } catch (_) {
          storageError =
              'Não foi possível salvar a sacola. As alterações ficam apenas nesta sessão.';
        }
        if (!_disposed) notifyListeners();
      });
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
