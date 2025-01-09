
part of '../../whispers/trucks_create_whisper.dart';

final SessionStorage _sessionStorage = SessionStorage.i;

final class _VehiculeModelViewAdapter implements TWSAutocompleteAdapter{
  const _VehiculeModelViewAdapter();

  @override
  Future<List<SetViewOut<VehiculeModel>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    String auth = _sessionStorage.session!.token;

     // Search filters;
    List<SetViewFilterNodeInterface<VehiculeModel>> filters = <SetViewFilterNodeInterface<VehiculeModel>>[];

    // -> Models filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<VehiculeModel> modelNameFilter = SetViewPropertyFilter<VehiculeModel>(0, SetViewFilterEvaluations.contians, 'Name', input);
      SetViewPropertyFilter<VehiculeModel> manufacturerNameFilter = SetViewPropertyFilter<VehiculeModel>(0, SetViewFilterEvaluations.contians, 'manufacturerNavigation.Name', input);
      List<SetViewFilterInterface<VehiculeModel>> searchFilterFilters = <SetViewFilterInterface<VehiculeModel>>[
        modelNameFilter,
        manufacturerNameFilter,
      ];
      // -> adding filters
      SetViewFilterLinearEvaluation<VehiculeModel> searchFilterOption = SetViewFilterLinearEvaluation<VehiculeModel>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      filters.add(searchFilterOption);
    }
    final SetViewOptions<VehiculeModel> options = SetViewOptions<VehiculeModel>(false, range, page, null, orderings, filters);
    final MainResolver<SetViewOut<VehiculeModel>> resolver = await Sources.foundationSource.vehiculesModels.view(options, auth);
    final SetViewOut<VehiculeModel> view = await resolver.act((JObject json) => SetViewOut<VehiculeModel>.des(json, VehiculeModel.des)).catchError(
          (Object x, StackTrace s) {
            const CSMAdvisor('VehiculeModel-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
            throw x;
          },
        );
    return <SetViewOut<VehiculeModel>>[view];
  }
}

final class _SituationsViewAdapter implements TWSAutocompleteAdapter{
  const _SituationsViewAdapter();
  
  @override
  Future<List<SetViewOut<Situation>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    String auth = _sessionStorage.session!.token;

    // Search filters;
    List<SetViewFilterNodeInterface<Situation>> filters = <SetViewFilterNodeInterface<Situation>>[];
    // -> Situations filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<Situation> situationNameFilter = SetViewPropertyFilter<Situation>(0, SetViewFilterEvaluations.contians, 'Name', input);
      // -> adding filters
      filters.add(situationNameFilter);
    }

    final SetViewOptions<Situation> options = SetViewOptions<Situation>(false, range, page, null, orderings, filters);
    final MainResolver<SetViewOut<Situation>> resolver = await Sources.foundationSource.situations.view(options, auth);
    final SetViewOut<Situation> view = await resolver.act((JObject json) => SetViewOut<Situation>.des(json, Situation.des)).catchError(
          (Object x, StackTrace s) {
            const CSMAdvisor('situation-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
            throw x;
          },
        );
    return <SetViewOut<Situation>>[view];
  }
}

final class _CarriersViewAdapter implements TWSAutocompleteAdapter {
  const _CarriersViewAdapter();
  
  @override
  Future<List<SetViewOut<Carrier>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    String auth = _sessionStorage.session!.token;
    // Search filters;

    List<SetViewFilterNodeInterface<Carrier>> filters = <SetViewFilterNodeInterface<Carrier>>[];
    // -> Carriers filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<Carrier> carrierNameFilter = SetViewPropertyFilter<Carrier>(0, SetViewFilterEvaluations.contians, 'Name', input);
      // -> adding filters
      filters.add(carrierNameFilter);
    }
    final SetViewOptions<Carrier> options =  SetViewOptions<Carrier>(false, range, page, null, orderings, filters);
    final MainResolver<SetViewOut<Carrier>> resolver = await Sources.foundationSource.carriers.view(options, auth);
    final SetViewOut<Carrier> view = await resolver.act((JObject json) => SetViewOut<Carrier>.des(json, Carrier.des)).catchError(
          (Object x, StackTrace s) {
            const CSMAdvisor('Carrier-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
            throw x;
          },
        );
    return <SetViewOut<Carrier>>[view];
  }
}

final class _ManufacturersViewAdapter implements TWSAutocompleteAdapter {
  const _ManufacturersViewAdapter();
  
  @override
  Future<List<SetViewOut<Manufacturer>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    String auth = _sessionStorage.session!.token;
    // Search filters;
    List<SetViewFilterNodeInterface<Manufacturer>> filters = <SetViewFilterNodeInterface<Manufacturer>>[];
    // -> Manufacturer filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<Manufacturer> manufacturerNameFilter = SetViewPropertyFilter<Manufacturer>(0, SetViewFilterEvaluations.contians, 'Name', input);
      // -> adding filters
      filters.add(manufacturerNameFilter);
    }
    final SetViewOptions<Manufacturer> options =  SetViewOptions<Manufacturer>(false, range, page, null, orderings, filters);
    final MainResolver<SetViewOut<Manufacturer>> resolver = await Sources.foundationSource.manufacturers.view(options, auth);
    final SetViewOut<Manufacturer> view = await resolver.act((JObject json) => SetViewOut<Manufacturer>.des(json, Manufacturer.des)).catchError(
          (Object x, StackTrace s) {
            const CSMAdvisor('Manufacturer-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
            throw x;
          },
        );
    return <SetViewOut<Manufacturer>>[view];
  }
}