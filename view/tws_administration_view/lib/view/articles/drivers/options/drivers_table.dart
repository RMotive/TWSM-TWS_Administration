part of '../drivers_article.dart';

/// [_DriversTable] component that build the [Truck] view table for Trucks Article.
class _DriversTable extends StatelessWidget {
  final TWSArticleTableAgent agent;
  final _TableAdapter adapter;
  const _DriversTable({
    required this.agent,
    required this.adapter,
  });

  @override
  Widget build(BuildContext context) {
    return TWSArticleTable<Driver>(
      editable: true,
      removable: false,
      adapter: adapter,
      agent: agent,
      fields: <TWSArticleTableFieldOptions<Driver>>[
        TWSArticleTableFieldOptions<Driver>(
          'License number',
          (Driver item, int index, BuildContext ctx) =>
              item.driverCommonNavigation?.license ?? '---',
        ),
        TWSArticleTableFieldOptions<Driver>(
          'Name',
          (Driver item, int index, BuildContext ctx) =>
              item.employeeNavigation?.identificationNavigation?.name ?? '---',
        ),
        TWSArticleTableFieldOptions<Driver>(
          'Father lastname',
          (Driver item, int index, BuildContext ctx) =>
              item.employeeNavigation?.identificationNavigation?.fatherlastname ?? '---',
        ),
        TWSArticleTableFieldOptions<Driver>(
          'Mother lastname',
          (Driver item, int index, BuildContext ctx) =>
              item.employeeNavigation?.identificationNavigation?.motherlastname ?? '---',
        ),
      ],
      page: 1,
      size: 25,
      sizes: const <int>[25, 50, 75, 100],
    );
  }
}
