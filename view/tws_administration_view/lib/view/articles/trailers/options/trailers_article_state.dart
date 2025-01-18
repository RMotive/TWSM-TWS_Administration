part of '../trailers_article.dart';
final class _TrailersArticleState extends CSMStateBase {

  final TWSArticleTableAgent tableAgent;

  /// view filters initialization.
  List<SetViewFilterNodeInterface<Trailer>> trailersFilters = <SetViewFilterNodeInterface<Trailer>>[];
  List<SetViewFilterNodeInterface<TrailerExternal>> externalsFilters = <SetViewFilterNodeInterface<TrailerExternal>>[];

  ///
  String searchFilter = '';

  _TrailersArticleState(this.tableAgent);

  filterSearch(String search) {
    print(search);
    searchFilter = search;

    _composeFilters();
  }

  _composeFilters() {
    trailersFilters = <SetViewFilterNodeInterface<Trailer>>[];
    externalsFilters = <SetViewFilterNodeInterface<TrailerExternal>>[];

    if (searchFilter.isNotEmpty) {
      SetViewPropertyFilter<Trailer> econoFilter = SetViewPropertyFilter<Trailer>(0, SetViewFilterEvaluations.contians, 'TrailerCommonNavigation.Economic', searchFilter);
      SetViewPropertyFilter<TrailerExternal> econoFilterExternal = SetViewPropertyFilter<TrailerExternal>(0, SetViewFilterEvaluations.contians, 'TrailerCommonNavigation.Economic', searchFilter);
      List<SetViewFilterInterface<Trailer>> searchFilterFilters = <SetViewFilterInterface<Trailer>>[
        econoFilter,
      ];
      List<SetViewFilterInterface<TrailerExternal>> externalSearchFilterFilters = <SetViewFilterInterface<TrailerExternal>>[
        econoFilterExternal,
      ];

      SetViewFilterLinearEvaluation<Trailer> searchFilterOption = SetViewFilterLinearEvaluation<Trailer>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      trailersFilters.add(searchFilterOption);
      SetViewFilterLinearEvaluation<TrailerExternal> externalSearchFilterOption = SetViewFilterLinearEvaluation<TrailerExternal>(2, SetViewFilterEvaluationOperators.or, externalSearchFilterFilters);
      externalsFilters.add(externalSearchFilterOption);
    }

    effect();
    tableAgent.refresh();
  }
}