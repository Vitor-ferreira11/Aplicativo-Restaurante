import 'package:flutter/material.dart';
import 'package:myapp/data/categories_data.dart';
import 'package:myapp/data/restaurant_data.dart';
import 'package:myapp/data/restaurant_search.dart';
import 'package:myapp/ui/_core/widgets/appbar.dart';
import 'package:myapp/ui/home/widgets/restaurant_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String? _category;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = filterRestaurants(
      context.watch<RestaurantData>().listRestaurant,
      query: _search.text,
      category: _category,
    );
    return Scaffold(
      appBar: getAppBar(context: context, title: 'TechTaste'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(child: Image.asset('assets/logo.png', width: 147)),
          const SizedBox(height: 24),
          Text(
            'Seu próximo sabor está aqui',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _search,
            decoration: InputDecoration(
              labelText: 'Buscar restaurante ou prato',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _search.text.isEmpty
                      ? null
                      : IconButton(
                        tooltip: 'Limpar busca',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(_search.clear),
                      ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Todos'),
                selected: _category == null,
                onSelected: (_) => setState(() => _category = null),
              ),
              for (final category in CategoriesData.listCategories)
                ChoiceChip(
                  label: Text(category),
                  selected: _category == category,
                  onSelected:
                      (selected) => setState(
                        () => _category = selected ? category : null,
                      ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '${restaurants.length} restaurante(s) encontrado(s)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          if (restaurants.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Nenhum restaurante encontrado. Experimente outra busca ou categoria.',
              ),
            ),
          for (final restaurant in restaurants)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RestaurantWidget(restaurant: restaurant),
            ),
        ],
      ),
    );
  }
}
