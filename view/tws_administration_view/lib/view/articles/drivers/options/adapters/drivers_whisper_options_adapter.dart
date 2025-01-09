
part of '../../whispers/drivers_create_whisper.dart';

final SessionStorage _sessionStorage = SessionStorage.i;

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

final class _EmployeeViewAdapter implements TWSAutocompleteAdapter{
  const _EmployeeViewAdapter();
  
  @override
  Future<List<SetViewOut<Employee>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    String auth = _sessionStorage.session!.token;

    // Search filters;
    List<SetViewFilterLinearEvaluation<Employee>> filters = <SetViewFilterLinearEvaluation<Employee>>[];
    // -> Situations filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<Employee> situationNameFilter = SetViewPropertyFilter<Employee>(0, SetViewFilterEvaluations.contians, 'IdentificationNavigation.Name', input);
      SetViewPropertyFilter<Employee> situationFlastnameFilter = SetViewPropertyFilter<Employee>(0, SetViewFilterEvaluations.contians, 'IdentificationNavigation.Fatherlastname', input);
      SetViewPropertyFilter<Employee> situationMlastnameFilter = SetViewPropertyFilter<Employee>(0, SetViewFilterEvaluations.contians, 'IdentificationNavigation.Motherlastname', input);
      
      // -> adding filters
      List<SetViewFilterInterface<Employee>> searchFilterFilters = <SetViewFilterInterface<Employee>>[
        situationNameFilter,
        situationFlastnameFilter,
        situationMlastnameFilter,
      ];      
      SetViewFilterLinearEvaluation<Employee> searchFilterOption = SetViewFilterLinearEvaluation<Employee>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      filters.add(searchFilterOption);
    }

    final SetViewOptions<Employee> options = SetViewOptions<Employee>(false, range, page, null, orderings, filters);
    final MainResolver<SetViewOut<Employee>> resolver = await Sources.foundationSource.employees.view(options, auth);
    final SetViewOut<Employee> view = await resolver.act((JObject json) => SetViewOut<Employee>.des(json, Employee.des)).catchError(
          (Object x, StackTrace s) {
            const CSMAdvisor('situation-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
            throw x;
          },
        );
    return <SetViewOut<Employee>>[view];
  }
}