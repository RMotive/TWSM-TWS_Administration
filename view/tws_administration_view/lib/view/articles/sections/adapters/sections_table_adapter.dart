part of '../sections_article.dart';

final SessionStorage _sessionStorage = SessionStorage.i;

final class _DialogState extends CSMStateBase {}
final _DialogState _dialogState = _DialogState();
void Function() _dialogEffect = (){};

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

final class _TableAdapter extends TWSArticleTableAdapter<Section> {
  final _SectionArticleState state;
  const _TableAdapter(this.state);

 @override
  Future<SetViewOut<Section>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<Section> options = SetViewOptions<Section>(false, range, page, null, orderings, state.sectionsFilters);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<Section>> resolver = await Sources.foundationSource.sections.view(options, auth);

    SetViewOut<Section> view = await resolver.act((JObject json) => SetViewOut<Section>.des(json, Section.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('sections-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }

  @override
  TWSArticleTableEditor? composeEditor(Section set, void Function() closeReinvoke, BuildContext context) {
    bool exceptionFlag = false;
    String xMessage = '---';

    return TWSArticleTableEditor(
      onCancel: closeReinvoke,
      onSave: () async {
        exceptionFlag = false;
        xMessage = '---';
        showDialog(
          context: context, 
          useRootNavigator: true,
          barrierDismissible: false,
          builder:(BuildContext context) {
            return CSMDynamicWidget<_DialogState>(
              state: _dialogState, 
              designer:(BuildContext ctx, _DialogState state) {
                _dialogEffect = state.effect;
                return exceptionFlag? TWSConfirmationDialog(
                  showCancelButton: false,
                  accept: 'OK',
                  title: 'Unexpected error on update.',
                  statement: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'Unexpected problem. Please retry the operation or contact your administrator.',
                      children: <InlineSpan>[
                        const TextSpan(
                          text: '\n\nError message:\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),                        
                        ),
                        TextSpan(
                         text: xMessage
                        ),
                      ],
                    ),
                  ),
                  onAccept: () {
                    Navigator.of(context).pop();
                  },
                ) :
                TWSConfirmationDialog(
                  accept: 'Update',
                  title: 'Section update confirmation',
                  onAccept: () async {
                    List<CSMSetValidationResult> evaluation = set.evaluate();
                    if(set.locationNavigation == null) evaluation.add(const CSMSetValidationResult("Location Navigation", "Location not selected", "emptyField()"));
                    if (evaluation.isEmpty) {
                      final String auth = _sessionStorage.getTokenStrict();
                      MainResolver<RecordUpdateOut<Section>> resolverUpdateOut =
                          await Sources.foundationSource.sections.update(set, auth);
                      try {
                        resolverUpdateOut
                            .act((JObject json) =>
                                RecordUpdateOut<Section>.des(json, Section.des))
                            .then(
                          (RecordUpdateOut<Section> updateOut) {
                            CSMRouter.i.pop();
                          },
                        ).onError(
                          (Object? x, _){
                            exceptionFlag = true;
                            xMessage = x.toString();
                            _dialogEffect();
                          }
                        );
                      } catch (x) {
                        exceptionFlag = true;
                        xMessage = x.toString();
                        _dialogEffect();
                      }
                    } else {
                      // --> Evaluation error dialog
                      CSMRouter.i.pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return TWSConfirmationDialog(
                            showCancelButton: false,
                            accept: 'Ok',
                            title: 'Invalid form data',
                            statement: Text.rich(
                              TextSpan(
                                text: 'Verify the data form:\n\n',
                                children: <InlineSpan>[
                                  for (int i = 0; i < evaluation.length; i++)
                                    TextSpan(
                                      text:
                                          "${i + 1} - ${evaluation[i].property}: ${evaluation[i].reason}\n",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                ],
                              ),
                            ),
                            onAccept: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    }
                  },
                  statement: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'Are you sure you want to update a location?',
                      children: <InlineSpan>[
                        const TextSpan(
                          text: '\n',
                        ),
                        const TextSpan(
                          text: '\n\u2022 Name:',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        WidgetSpan(
                          baseline: TextBaseline.alphabetic,
                          alignment: PlaceholderAlignment.bottom,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Text('\n${set.name}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Location name:',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        WidgetSpan(
                          baseline: TextBaseline.alphabetic,
                          alignment: PlaceholderAlignment.bottom,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Text('\n${set.locationNavigation?.name ?? '---'}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Capacity:',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        WidgetSpan(
                          baseline: TextBaseline.alphabetic,
                          alignment: PlaceholderAlignment.bottom,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Text('\n${set.capacity}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Ocupancy:',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        WidgetSpan(
                          baseline: TextBaseline.alphabetic,
                          alignment: PlaceholderAlignment.bottom,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Text('\n${set.ocupancy}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      form: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: CSMSpacingColumn(
            spacing: 10,
            children: <Widget>[
              TWSInputText(
                label: 'Name',
                hint: 'Insert a name',
                maxLength: 32,
                controller: TextEditingController(
                  text: set.name,
                ),
                onChanged: (String text) {
                  set.name = text;
                },
              ),
              TWSAutoCompleteField<Location>(
                width: double.maxFinite,
                label: 'Location',
                isOptional: true,
                initialValue: set.locationNavigation,
                adapter: const _LocationsViewAdapter(),
                displayValue:(Location? item) => item?.name ?? "Not valid data",
                onChanged: (Location? item) {
                  set = set.clone(
                    yard: item?.id ?? 0,
                    locationNavigation: item
                  );
                },
              ),
              TWSInputText(
                label: 'Capacity',
                hint: 'Insert a capacity',
                keyboardType: TextInputType.number,
                formatter: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                controller: TextEditingController(
                  text: set.capacity.toString(),
                ),
                onChanged: (String text) {
                  set.capacity = int.tryParse(text) ?? 0;
                },
              ),
              TWSInputText(
                label: 'Ocupancy',
                hint: 'Insert a ocupancy',
                keyboardType: TextInputType.number,
                formatter: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                controller: TextEditingController(
                  text: set.ocupancy.toString(),
                ),
                onChanged: (String text) {
                  set.ocupancy = int.tryParse(text) ?? 0;
                },
              ),
            ],
          ),
        ),
      ), 

    );
  }
  
  @override
  Widget? composeViewer(Section set, BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        child: CSMSpacingColumn(
          spacing: 10,
          children: <Widget>[
            TWSPropertyViewer(
              label: "Name",
              value: set.name,
            ),
            TWSPropertyViewer(
              label: "Location",
              value: set.locationNavigation?.name ?? '---',
            ),
            TWSPropertyViewer(
              label: "Capacity",
              value: set.capacity.toString(),
            ),
            TWSPropertyViewer(
              label: "Ocupancy",
              value: set.ocupancy.toString(),
            ),
          ],
        ),
      ),
    );
  }
}