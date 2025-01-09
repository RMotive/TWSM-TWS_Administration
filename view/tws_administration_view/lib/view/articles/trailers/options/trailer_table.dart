part of '../trailers_article.dart';

/// [_TrailerTable] component that build the [Truck] view table for Trucks Article.
class _TrailerTable extends StatelessWidget {
  final TWSArticleTableAgent agent;
  final _TableAdapter adapter;
  const _TrailerTable({
    required this.agent,
    required this.adapter,
  });

  @override
  Widget build(BuildContext context) {
    return TWSArticleTable<Trailer>(
      editable: true,
      removable: false,
      adapter: adapter,
      agent: agent,
      fields: <TWSArticleTableFieldOptions<Trailer>>[
        TWSArticleTableFieldOptions<Trailer>(
          'Economic',
          (Trailer item, int index, BuildContext ctx) =>
              item.trailerCommonNavigation?.economic ?? '---',
        ),
        TWSArticleTableFieldOptions<Trailer>(
          'Plates',
          (Trailer item, int index, BuildContext ctx) => adapter.getPlates(item),
          true,
        ),
      ],
      page: 1,
      size: 25,
      sizes: const <int>[25, 50, 75, 100],
    );
  }
}
