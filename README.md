# TechTaste — aplicativo de restaurantes

Projeto educacional em Flutter com catálogo local, busca, filtros e sacola persistida. A finalização é uma **demonstração**, sem cobrança, backend ou envio de pedidos ao restaurante.

## Funcionalidades

- Busca por restaurante, descrição ou nome do prato, ignorando caixa e acentos.
- Filtros por categoria combinados com a busca; opção Todos e estado sem resultados.
- Adição e remoção de unidades, agrupadas pelo identificador do prato, com limite de 99 por item.
- Subtotais e total calculados em centavos e apresentados em reais.
- Sacola salva localmente com `SharedPreferencesAsync`; restauração usa preços e pratos do catálogo atual.
- Confirmação cancelável e recibo do pedido simulado; confirmar limpa a sacola.
- Aviso quando o armazenamento local não está disponível, mantendo o uso na sessão.

## Executar

Validado com Flutter 3.29.3 / Dart 3.7. Respeite as restrições de SDK do `pubspec.yaml`.

```sh
flutter pub get
flutter run -d chrome
```

Android/iOS e desktop exigem suas ferramentas de plataforma. No Windows, compilações com plugins podem exigir suporte a links simbólicos; a CI usa Linux.

## Verificar

```sh
flutter analyze
flutter test
flutter build web
```

Os testes cobrem quantidades, remoção, notificações, restauração com preço atual, limpeza persistida, dados inválidos, falhas de gravação, limites, busca e combinação de filtros. Os testes de interface verificam uma lista longa em tela pequena e o fluxo de confirmação/cancelamento da demonstração. A CI executa análise, testes e build web.

## Estrutura

- `lib/data`: catálogo, categorias, busca e interface de armazenamento.
- `lib/model`: restaurantes e pratos.
- `lib/ui`: catálogo, restaurante e sacola.
- `lib/ui/_core/bag_provider.dart`: estado, totais e fila de gravação da sacola.
- `assets/data.json`: fonte local dos dados.

## Limitações

Os dados são de demonstração. A persistência é local ao dispositivo/navegador, sem conta ou sincronização; limpar os dados do aplicativo apaga a sacola. Preferências locais não oferecem garantias para dados financeiros ou pedidos reais. O preço do catálogo é inteiro em reais e convertido para centavos para os cálculos. Não há entrega, autenticação, estoque, pagamento ou histórico de pedidos.
