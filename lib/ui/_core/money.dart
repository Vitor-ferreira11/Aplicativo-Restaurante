String formatMoney(int cents) =>
    'R\$ ${(cents / 100).toStringAsFixed(2).replaceAll('.', ',')}';
