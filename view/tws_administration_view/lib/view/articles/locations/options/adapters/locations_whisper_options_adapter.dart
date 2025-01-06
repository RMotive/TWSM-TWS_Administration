part of '../../whispers/locations_create_whisper.dart';

final SessionStorage _sessionStorage = SessionStorage.i;

final class _AddressesViewAdapter implements TWSAutocompleteAdapter{
  const _AddressesViewAdapter();
  
  @override
  Future<List<SetViewOut<Address>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    String auth = _sessionStorage.session!.token;

    // Search filters;
    List<SetViewFilterNodeInterface<Address>> filters = <SetViewFilterNodeInterface<Address>>[];
    // -> Situations filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<Address> streetFilter = SetViewPropertyFilter<Address>(0, SetViewFilterEvaluations.contians, 'Street', input);
      SetViewPropertyFilter<Address> coloniaFilter = SetViewPropertyFilter<Address>(0, SetViewFilterEvaluations.contians, 'Colonia', input);
      SetViewPropertyFilter<Address> zipFilter = SetViewPropertyFilter<Address>(0, SetViewFilterEvaluations.contians, 'ZIP', input);

      // -> adding filters
      List<SetViewFilterInterface<Address>> searchFilterFilters = <SetViewFilterInterface<Address>>[
        streetFilter,
        coloniaFilter,
        zipFilter,
      ];      
      SetViewFilterLinearEvaluation<Address> searchFilterOption = SetViewFilterLinearEvaluation<Address>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      filters.add(searchFilterOption);
    }

    final SetViewOptions<Address> options = SetViewOptions<Address>(false, range, page, null, orderings, filters);
    final MainResolver<SetViewOut<Address>> resolver = await Sources.foundationSource.addresses.view(options, auth);
    final SetViewOut<Address> view = await resolver.act((JObject json) => SetViewOut<Address>.des(json, Address.des)).catchError(
          (Object x, StackTrace s) {
            const CSMAdvisor('situation-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
            throw x;
          },
        );
    return <SetViewOut<Address>>[view];
  }
}