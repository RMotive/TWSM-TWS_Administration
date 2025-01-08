part of '../whispers/sections_create_whisper.dart';

final SessionStorage _sessionStorage = SessionStorage.i;

final class _LocationsViewAdapter implements TWSAutocompleteAdapter{
  const _LocationsViewAdapter();
  
  @override
  Future<List<SetViewOut<Location>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    String auth = _sessionStorage.session!.token;

    // Search filters;
    List<SetViewFilterNodeInterface<Location>> filters = <SetViewFilterNodeInterface<Location>>[];
    // -> Situations filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<Location> nameFilter = SetViewPropertyFilter<Location>(0, SetViewFilterEvaluations.contians, 'Name', input);
      // -> adding filters
      filters.add(nameFilter);
    }

    final SetViewOptions<Location> options = SetViewOptions<Location>(false, range, page, null, orderings, filters);
    final MainResolver<SetViewOut<Location>> resolver = await Sources.foundationSource.locations.view(options, auth);
    final SetViewOut<Location> view = await resolver.act((JObject json) => SetViewOut<Location>.des(json, Location.des)).catchError(
          (Object x, StackTrace s) {
            const CSMAdvisor('situation-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
            throw x;
          },
        );
    return <SetViewOut<Location>>[view];
  }
}