part of '../truck_inventory_article.dart';

///
final class _InventoryPageState extends CSMStateBase {
  static final DateTime initDate = DateTime(2024, 09, 01);

  final TWSArticleTableAgent tableAgent;

  ///
  List<SetViewFilterNodeInterface<YardLog>> filters = <SetViewFilterNodeInterface<YardLog>>[];

  ///
  Section? sectionFilter;

  ///
  String searchFilter = '';

  ///
  (DateTime from, DateTime? to) dateFilter = (initDate, null);

  ///
  _InventoryPageState(this.tableAgent) {
    SetViewDateFilter<YardLog> dateFilterOption = SetViewDateFilter<YardLog>(0, dateFilter.$1, dateFilter.$2);
    filters.add(dateFilterOption);
  }

  filterSection(Section? section) {
    if (sectionFilter == section) return;
    sectionFilter = section;

    _composeFilters();
  }

  filterDate(DateTime from, DateTime? to) {
    dateFilter = (from, to);

    _composeFilters();
  }

  filterSearch(String search) {
    searchFilter = search;

    _composeFilters();
  }

   _composeFilters() {
    filters = <SetViewFilterNodeInterface<YardLog>>[];

    SetViewDateFilter<YardLog> dateFilterOption = SetViewDateFilter<YardLog>(0, dateFilter.$1, dateFilter.$2);
    filters.add(dateFilterOption);

    if (sectionFilter != null) {
      SetViewFilterNodeInterface<YardLog> nodeFilter = SetViewPropertyFilter<YardLog>(1, SetViewFilterEvaluations.equal, YardLog.kSection, sectionFilter!.id);
      filters.add(nodeFilter);
    }

    if (searchFilter.isNotEmpty) {
      SetViewPropertyFilter<YardLog> econoFilter = SetViewPropertyFilter<YardLog>(0, SetViewFilterEvaluations.contians, 'TrailerNavigation.TrailerCommonNavigation.Economic', searchFilter);
      SetViewPropertyFilter<YardLog> econoFilterExternal =
          SetViewPropertyFilter<YardLog>(0, SetViewFilterEvaluations.contians, 'TrailerExternalNavigation.TrailerCommonNavigation.Economic', searchFilter);
      List<SetViewFilterInterface<YardLog>> searchFilterFilters = <SetViewFilterInterface<YardLog>>[
        econoFilter,
        econoFilterExternal,
      ];

      SetViewFilterLinearEvaluation<YardLog> searchFilterOption = SetViewFilterLinearEvaluation<YardLog>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      filters.add(searchFilterOption);
    }

    effect();
    tableAgent.refresh();
  }
}
