part of '../trucks_article.dart';

/// [_TruckTable] component that build the [TruckExternal] view table for Trucks Article.
class _TruckExternalTable extends StatelessWidget {
  final TWSArticleTableAgent agent;
  final TWSArticleTableAdapter<TruckExternal> adapter;

  const _TruckExternalTable({required this.agent, required this.adapter});

  @override
  Widget build(BuildContext context) {
    return TWSArticleTable<TruckExternal>(
      editable: true,
      removable: false,
      agent: agent,
      adapter: adapter,
      fields: <TWSArticleTableFieldOptions<TruckExternal>>[
        TWSArticleTableFieldOptions<TruckExternal>(
          'Economic',
          (TruckExternal item, int index, BuildContext ctx) => item.truckCommonNavigation!.economic,
        ),
        TWSArticleTableFieldOptions<TruckExternal>(
          'USA Plate',
          (TruckExternal item, int index, BuildContext ctx) => item.usaPlate ?? "---",
        ),
        TWSArticleTableFieldOptions<TruckExternal>(
          'MX Plate',
          (TruckExternal item, int index, BuildContext ctx) => item.mxPlate ?? "---",
        ),
      ],
      page: 1,
      size: 25,
      sizes: const <int>[25, 50, 75, 100],
    );
  }
}
