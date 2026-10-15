import 'package:flutter/material.dart';
import 'package:myapp/ui/_core/bag_provider.dart';
import 'package:myapp/ui/_core/money.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _submitting = false;

  Future<void> _finish() async {
    final bag = context.read<BagProvider>();
    if (_submitting || bag.dishesOnBag.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar demonstração?'),
            content: Text(
              'Total: ${formatMoney(bag.totalInCents)}. Este pedido é uma simulação: não haverá pagamento ou envio ao restaurante.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Voltar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirmar demonstração'),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _submitting = true);
    final total = bag.totalInCents;
    final items =
        bag
            .getMapByAmount()
            .entries
            .map((e) => '${e.value} × ${e.key.name}')
            .toList();
    bag.clearBag();
    await bag.whenSaved;
    if (!mounted) return;
    setState(() => _submitting = false);
    await showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Demonstração concluída'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...items.map(Text.new),
                  const SizedBox(height: 16),
                  Text('Total simulado: ${formatMoney(total)}'),
                  const Text(
                    'Nenhum pagamento foi cobrado e nenhum pedido foi enviado.',
                  ),
                  if (bag.storageError != null) Text(bag.storageError!),
                ],
              ),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Continuar explorando'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bag = context.watch<BagProvider>();
    final entries = bag.getMapByAmount().entries.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sacola'),
        actions: [
          TextButton(
            onPressed: entries.isEmpty || _submitting ? null : bag.clearBag,
            child: const Text('Limpar'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Pedido de demonstração. Sem pagamento ou envio real.'),
          if (bag.storageError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                bag.storageError!,
                style: const TextStyle(color: Colors.orange),
              ),
            ),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Sua sacola está vazia. Adicione um prato para começar.',
              ),
            ),
          for (final entry in entries)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(entry.key.name),
              subtitle: Text(
                '${formatMoney(entry.key.price * 100)} por unidade · Subtotal: ${formatMoney(entry.key.price * 100 * entry.value)}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Remover uma unidade de ${entry.key.name}',
                    onPressed:
                        _submitting ? null : () => bag.removeDish(entry.key),
                    icon: const Icon(Icons.remove),
                  ),
                  Text('${entry.value}'),
                  IconButton(
                    tooltip: 'Adicionar uma unidade de ${entry.key.name}',
                    onPressed:
                        _submitting || entry.value >= 99
                            ? null
                            : () => bag.addAllDishes([entry.key]),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          const Divider(),
          Text(
            'Total: ${formatMoney(bag.totalInCents)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: entries.isEmpty || _submitting ? null : _finish,
            child: Text(
              _submitting ? 'Concluindo...' : 'Finalizar demonstração',
            ),
          ),
        ],
      ),
    );
  }
}
