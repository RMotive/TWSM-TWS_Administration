part of '../truck_inventory_article.dart';

final SessionStorage _sessionStorage = SessionStorage.i;


final class _TableAdapter extends TWSArticleTableAdapter<YardLog> {
  final _InventoryPageState state;

  const _TableAdapter(this.state);

  String getPlates(YardLog item, bool isMXplate){
    if(isMXplate) return item.truckNavigation?.plates.where((Plate i) => i.country == TWSAMessages.kCountryList[1]).lastOrNull?.identifier ?? item.truckExternalNavigation?.mxPlate ?? '---';
    return item.truckNavigation?.plates.where((Plate i) => i.country == TWSAMessages.kCountryList[0]).lastOrNull?.identifier ?? item.truckExternalNavigation?.usaPlate ?? '---';
  }

  @override
  Future<SetViewOut<YardLog>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<YardLog> options = SetViewOptions<YardLog>(false, range, page, null, orderings, state.filters);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<YardLog>> resolver = await Sources.foundationSource.yardLogs.viewInventory(options, auth);

    SetViewOut<YardLog> view = await resolver.act((Map<String, dynamic> json) => SetViewOut<YardLog>.des(json, YardLog.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('yard-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }
  
  @override
  TWSArticleTableEditor? composeEditor(YardLog set, Function closeReinvoke, BuildContext context) {
    return null;
  }

  @override
  Widget composeViewer(YardLog set, BuildContext context) {
    return SizedBox.expand(
      child: CSMSpacingColumn(
        spacing: 12,
        crossAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TWSPropertyViewer(
            label: 'Economic',
            value: set.truckNavigation?.truckCommonNavigation?.economic ?? set.truckExternalNavigation?.truckCommonNavigation?.economic ?? "---",
          ),
          TWSPropertyViewer(
            label: 'MX Plate',
            value: getPlates(set, true),
          ),
          TWSPropertyViewer(
            label: 'USA PLate',
            value: getPlates(set, false),
          ),
          TWSPropertyViewer(
            label: 'Carrier',
            value: '${set.sectionNavigation?.name} - ${set.sectionNavigation?.locationNavigation?.name}',
          ),
          TWSPropertyViewer(
            label: 'Section',
            value: set.sectionNavigation?.name ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Ownership',
            value: set.truck != null? "Own" : "External",
          ),
        ],
      ),
    );
  }
}

final class _SectionViewAdapter implements TWSAutocompleteAdapter {
  const _SectionViewAdapter();

  @override
  Future<List<SetViewOut<dynamic>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    List<SetViewOut<dynamic>> rawViews = <SetViewOut<dynamic>>[];
    String auth = _sessionStorage.session!.token;

     // Search filters;
    List<SetViewFilterNodeInterface<Section>> filters = <SetViewFilterNodeInterface<Section>>[];

    // -> Sections filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<Section> sectionNameFilter = SetViewPropertyFilter<Section>(0, SetViewFilterEvaluations.contians, 'Name', input);
      SetViewPropertyFilter<Section> locationNameFilter = SetViewPropertyFilter<Section>(0, SetViewFilterEvaluations.contians, 'LocationNavigation.Name', input);
      List<SetViewFilterInterface<Section>> searchFilterFilters = <SetViewFilterInterface<Section>>[
        sectionNameFilter,
        locationNameFilter,
      ];
      // -> adding filters
      SetViewFilterLinearEvaluation<Section> searchFilterOption = SetViewFilterLinearEvaluation<Section>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      filters.add(searchFilterOption);
    }

    final SetViewOptions<Section> options = SetViewOptions<Section>(false, range, page, null, orderings, filters);

    final MainResolver<SetViewOut<Section>> resolver = await Sources.foundationSource.sections.view(options, auth);
    final SetViewOut<Section> view = await resolver.act((Map<String, dynamic> json) => SetViewOut<Section>.des(json, Section.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('trailerExternal-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
        throw x;
      },
    );
    rawViews.add(view);
    return rawViews;
  }
}

