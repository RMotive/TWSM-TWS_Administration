part of '../locations_article.dart';
final class _LocationssArticleState extends CSMStateBase {

  final TWSArticleTableAgent tableAgent;

  /// view filters initialization.
  List<SetViewFilterNodeInterface<Location>> locationsFilters = <SetViewFilterNodeInterface<Location>>[];

  ///
  String nameFilter = '';

  _LocationssArticleState(this.tableAgent);

  filterName(String search) {
    nameFilter = search;

    _composeFilters();
  }

  _composeFilters() {
    locationsFilters = <SetViewFilterNodeInterface<Location>>[];
    
    if (nameFilter.isNotEmpty) {
      SetViewPropertyFilter<Location> nFilter = SetViewPropertyFilter<Location>(0, SetViewFilterEvaluations.contians, 'Name', nameFilter);
      List<SetViewFilterInterface<Location>> searchFilterFilters = <SetViewFilterInterface<Location>>[
        nFilter,
      ];

      SetViewFilterLinearEvaluation<Location> searchFilterOption = SetViewFilterLinearEvaluation<Location>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      locationsFilters.add(searchFilterOption);

    }

    effect();
    tableAgent.refresh();
  }
}