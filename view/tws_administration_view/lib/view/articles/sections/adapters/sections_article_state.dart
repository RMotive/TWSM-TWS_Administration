part of '../sections_article.dart';
final class _SectionArticleState extends CSMStateBase {

  final TWSArticleTableAgent tableAgent;

  /// view filters initialization.
  List<SetViewFilterNodeInterface<Section>> sectionsFilters = <SetViewFilterNodeInterface<Section>>[];

  ///
  String nameFilter = '';

  ///
  String locationFilter = '';

  _SectionArticleState(this.tableAgent);

  filterName(String search) {
    nameFilter = search;

    _composeFilters();
  }

  filterLocation(String search) {
    locationFilter = search;

    _composeFilters();
  }

  _composeFilters() {
    sectionsFilters = <SetViewFilterNodeInterface<Section>>[];
    
    if (nameFilter.isNotEmpty) {
      SetViewPropertyFilter<Section> nFilter = SetViewPropertyFilter<Section>(0, SetViewFilterEvaluations.contians, 'Name', nameFilter);
      List<SetViewFilterInterface<Section>> searchFilters = <SetViewFilterInterface<Section>>[
        nFilter,
      ];

      SetViewFilterLinearEvaluation<Section> searchFilterOption = SetViewFilterLinearEvaluation<Section>(2, SetViewFilterEvaluationOperators.or, searchFilters);
      sectionsFilters.add(searchFilterOption);
    }

    if (locationFilter.isNotEmpty) {
      SetViewPropertyFilter<Section> lFilter = SetViewPropertyFilter<Section>(0, SetViewFilterEvaluations.contians, 'LocationNavigation.Name', locationFilter);
      List<SetViewFilterInterface<Section>> searchFilters = <SetViewFilterInterface<Section>>[
        lFilter,
      ];

      SetViewFilterLinearEvaluation<Section> searchFilterOption = SetViewFilterLinearEvaluation<Section>(2, SetViewFilterEvaluationOperators.or, searchFilters);
      sectionsFilters.add(searchFilterOption);
    }

    effect();
    tableAgent.refresh();
  }
}