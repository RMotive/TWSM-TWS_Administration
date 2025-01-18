part of '../trucks_article.dart';
final class _TrucksArticleState extends CSMStateBase {

  final TWSArticleTableAgent tableAgent;

  /// view filters initialization.
  List<SetViewFilterNodeInterface<Truck>> trucksFilters = <SetViewFilterNodeInterface<Truck>>[];
  List<SetViewFilterNodeInterface<TruckExternal>> externalsFilters = <SetViewFilterNodeInterface<TruckExternal>>[];

  ///
  String searchFilter = '';

  _TrucksArticleState(this.tableAgent);

  filterSearch(String search) {
    print(search);
    searchFilter = search;

    _composeFilters();
  }

  _composeFilters() {
    trucksFilters = <SetViewFilterNodeInterface<Truck>>[];
    externalsFilters = <SetViewFilterNodeInterface<TruckExternal>>[];

    if (searchFilter.isNotEmpty) {
      SetViewPropertyFilter<Truck> econoFilter = SetViewPropertyFilter<Truck>(0, SetViewFilterEvaluations.contians, 'TruckCommonNavigation.Economic', searchFilter);
      SetViewPropertyFilter<TruckExternal> econoFilterExternal = SetViewPropertyFilter<TruckExternal>(0, SetViewFilterEvaluations.contians, 'TruckCommonNavigation.Economic', searchFilter);
      List<SetViewFilterInterface<Truck>> searchFilterFilters = <SetViewFilterInterface<Truck>>[
        econoFilter,
      ];
      List<SetViewFilterInterface<TruckExternal>> externalSearchFilterFilters = <SetViewFilterInterface<TruckExternal>>[
        econoFilterExternal,
      ];

      SetViewFilterLinearEvaluation<Truck> searchFilterOption = SetViewFilterLinearEvaluation<Truck>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      trucksFilters.add(searchFilterOption);
      SetViewFilterLinearEvaluation<TruckExternal> externalSearchFilterOption = SetViewFilterLinearEvaluation<TruckExternal>(2, SetViewFilterEvaluationOperators.or, externalSearchFilterFilters);
      externalsFilters.add(externalSearchFilterOption);
    }

    effect();
    tableAgent.refresh();
  }
}