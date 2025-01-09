part of '../trucks_article.dart';

/// [_TruckTable] component that build the [Truck] view table for Trucks Article.
class _TruckTable extends StatelessWidget {
  final TWSArticleTableAgent agent;
  final _TableAdapter adapter;
  const _TruckTable({
    required this.agent,
    required this.adapter,
  });

  @override
  Widget build(BuildContext context) {
    return TWSArticleTable<Truck>(
      editable: true,
      removable: false,
      adapter: adapter,
      agent: agent,
      fields: <TWSArticleTableFieldOptions<Truck>>[
        TWSArticleTableFieldOptions<Truck>(
          'Economic',
          (Truck item, int index, BuildContext ctx) =>
              item.truckCommonNavigation?.economic ?? '---',
        ),
        TWSArticleTableFieldOptions<Truck>(
          'Plates',
          (Truck item, int index, BuildContext ctx) => adapter.getPlates(item),
          true,
        ),
      ],
      page: 1,
      size: 25,
      sizes: const <int>[25, 50, 75, 100],
    );
  }
}
