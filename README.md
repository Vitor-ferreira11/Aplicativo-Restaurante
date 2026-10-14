# TechTaste — aplicativo de restaurantes

Projeto de estudo em Flutter com catálogo de restaurantes, pratos e sacola. Os dados são carregados de `assets/data.json`; não há backend, pagamento ou envio real de pedidos implementado.

## Executar

Use Flutter compatível com Dart 3.7 ou superior, respeitando a restrição de SDK em `pubspec.yaml`. A verificação desta proposta usa Flutter 3.29.3.

```
flutter pub get
flutter run
```

Escolha um dispositivo disponível. Android/iOS e desktop exigem suas ferramentas de plataforma; para navegador, use `flutter run -d chrome`.

## Verificar

```
flutter analyze
flutter test
flutter build web
```

Os testes verificam a sacola vazia, agrupamento de quantidades, remoção de uma unidade, limpeza e notificações aos ouvintes. Um teste de interface em tela de 400 × 600 verifica rolagem de uma lista longa, adição de prato, abertura da sacola e remoção. Substituem o teste de contador do modelo Flutter, que não correspondia a este aplicativo.

O SDK mínimo foi ajustado para Dart 3.7 estável e o lockfile foi atualizado para as dependências exigidas pelo Flutter 3.29.3. O fluxo de verificações do GitHub executa análise, testes e build web.

## Estrutura

- `lib/data`: leitura do catálogo e categorias.
- `lib/model`: restaurantes e pratos.
- `lib/ui`: splash, catálogo, restaurante e sacola.
- `lib/ui/_core/bag_provider.dart`: estado da sacola via Provider.
- `assets`: imagens e catálogo local.

## Limitações

A sacola fica em memória e é perdida ao reiniciar o aplicativo. Não há fluxo de compra completo. O agrupamento atual depende da mesma instância de Dish, pois o modelo não define igualdade por identificador; a mudança dessa regra deve ser avaliada separadamente.
