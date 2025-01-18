part of '../trailers_article.dart';

/// [_TrailerTable] component that build the [TruckExternal] view table for Trucks Article.
class _TrailerExternalTable extends StatelessWidget {
  final TWSArticleTableAgent agent;
  final TWSArticleTableAdapter<TrailerExternal> adapter;

  const _TrailerExternalTable({required this.agent, required this.adapter});

  @override
  Widget build(BuildContext context) {
    return TWSArticleTable<TrailerExternal>(
      editable: true,
      removable: false,
      agent: agent,
      adapter: adapter,
      fields: <TWSArticleTableFieldOptions<TrailerExternal>>[
        TWSArticleTableFieldOptions<TrailerExternal>(
          'Economic',
          (TrailerExternal item, int index, BuildContext ctx) => item.trailerCommonNavigation!.economic,
        ),
        TWSArticleTableFieldOptions<TrailerExternal>(
          'USA Plate',
          (TrailerExternal item, int index, BuildContext ctx) => item.usaPlate ?? "---",
        ),
        TWSArticleTableFieldOptions<TrailerExternal>(
          'MX Plate',
          (TrailerExternal item, int index, BuildContext ctx) => item.mxPlate ?? "---",
        ),
      ],
      page: 1,
      size: 25,
      sizes: const <int>[25, 50, 75, 100],
    );
  }
}
