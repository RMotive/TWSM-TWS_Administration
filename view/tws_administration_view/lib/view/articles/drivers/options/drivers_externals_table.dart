part of '../drivers_article.dart';

/// [_DriversTable] component that build the [Truck] view table for Trucks Article.
class _DriversExternalTable extends StatelessWidget {
  final TWSArticleTableAgent agent;
  final _ExternalTableAdapter adapter;
  const _DriversExternalTable({
    required this.agent,
    required this.adapter,
  });

  @override
  Widget build(BuildContext context) {
    return TWSArticleTable<DriverExternal>(
      editable: true,
      removable: false,
      adapter: adapter,
      agent: agent,
      fields: <TWSArticleTableFieldOptions<DriverExternal>>[
        TWSArticleTableFieldOptions<DriverExternal>(
          'License number',
          (DriverExternal item, int index, BuildContext ctx) =>
              item.driverCommonNavigation?.license ?? '---',
        ),
        TWSArticleTableFieldOptions<DriverExternal>(
          'Name',
          (DriverExternal item, int index, BuildContext ctx) =>
              item.identificationNavigation?.name ?? '---',
        ),
        TWSArticleTableFieldOptions<DriverExternal>(
          'Father lastname',
          (DriverExternal item, int index, BuildContext ctx) =>
              item.identificationNavigation?.fatherlastname ?? '---',
        ),
        TWSArticleTableFieldOptions<DriverExternal>(
          'Mother lastname',
          (DriverExternal item, int index, BuildContext ctx) =>
              item.identificationNavigation?.motherlastname ?? '---',
        ),
      ],
      page: 1,
      size: 25,
      sizes: const <int>[25, 50, 75, 100],
    );
  }
}
