part of '../../trailers_article.dart';

// This document stores all consume classes for Trailer table and update options.
final SessionStorage _sessionStorage = SessionStorage.i;
class _PlatesState extends CSMStateBase{}
final _PlatesState _platesState = _PlatesState();
void Function() _platesFormsState = (){};

final class _TrailerTypeViewAdapter implements TWSAutocompleteAdapter{
  const _TrailerTypeViewAdapter();

  @override
  Future<List<SetViewOut<TrailerType>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    String auth = _sessionStorage.session!.token;

     // Search filters;
    List<SetViewFilterNodeInterface<TrailerType>> filters = <SetViewFilterNodeInterface<TrailerType>>[];

    // -> Models filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<TrailerType> sizeFilter = SetViewPropertyFilter<TrailerType>(0, SetViewFilterEvaluations.contians, 'Size', input);
      SetViewPropertyFilter<TrailerType> typeFilter = SetViewPropertyFilter<TrailerType>(0, SetViewFilterEvaluations.contians, 'TrailerClassNavigation.Name', input);
      List<SetViewFilterInterface<TrailerType>> searchFilterFilters = <SetViewFilterInterface<TrailerType>>[
        sizeFilter,
        typeFilter,
      ];
      // -> adding filters
      SetViewFilterLinearEvaluation<TrailerType> searchFilterOption = SetViewFilterLinearEvaluation<TrailerType>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      filters.add(searchFilterOption);
    }
    final SetViewOptions<TrailerType> options = SetViewOptions<TrailerType>(false, range, page, null, orderings, filters);
    final MainResolver<SetViewOut<TrailerType>> resolver = await Sources.foundationSource.trailersTypes.view(options, auth);
    final SetViewOut<TrailerType> view = await resolver.act((JObject json) => SetViewOut<TrailerType>.des(json, TrailerType.des)).catchError(
          (Object x, StackTrace s) {
            const CSMAdvisor('TrailerType-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
            throw x;
          },
        );
    return <SetViewOut<TrailerType>>[view];
  }
}

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
    final SetViewOptions<Situation> options =  SetViewOptions<Situation>(false, range, page, null, orderings, <SetViewFilterNodeInterface<Situation>>[]);
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

/// [_TableAdapter] class stores consumes the data and all the compose components for the table [TrailerExternal] table.
final class _TableAdapter extends TWSArticleTableAdapter<Trailer> {
  const _TableAdapter();

  String getPlates(Trailer item){
    String plates = '---';
    if (item.plates.isNotEmpty) {
      plates = '';
      for (int cont = 0; cont < item.plates.length; cont++) {
        plates += item.plates[cont].identifier;
        if (item.plates.length > cont) plates += '\n';
      }
    }
    return plates;
  }

  
  @override
  Future<SetViewOut<Trailer>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<Trailer> options = SetViewOptions<Trailer>(false, range, page, null, orderings, <SetViewFilterNodeInterface<Trailer>>[]);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<Trailer>> resolver = await Sources.foundationSource.trailers.view(options, auth);

    SetViewOut<Trailer> view = await resolver.act((JObject json) => SetViewOut<Trailer>.des(json, Trailer.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('Trailer-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }
  
  @override
  TWSArticleTableEditor? composeEditor(
      Trailer set, Function closeReinvoke, BuildContext context) {
    return TWSArticleTableEditor(
      onCancel: closeReinvoke,
      onSave: () async {
        showDialog(
          context: context,
          useRootNavigator: true,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return TWSConfirmationDialog(
              accept: 'Update',
              title: 'Trailer update confirmation',
              statement: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                    text: 'Are you sure you want to update a trailer?',
                  children: <InlineSpan>[
                    const TextSpan(
                      text: '\n',
                    ),
                    const TextSpan(
                      text: '\n\u2022 Economic:',
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
                        child: Text('\n${set.trailerCommonNavigation?.economic ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Carrier:',
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
                        child: Text('\n${set.carrierNavigation?.name ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Type:',
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
                        child: Text( set.trailerCommonNavigation?.trailerTypeNavigation?.trailerClassNavigation?.name != null? 
                          '\n${set.trailerCommonNavigation?.trailerTypeNavigation?.trailerClassNavigation?.name} - ${set.trailerCommonNavigation?.trailerTypeNavigation?.size}': "---",
                        ),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Model:',
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
                        child: Text('\n${set.vehiculeModelNavigation?.name ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Situation:',
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
                        child: Text('\n${set.trailerCommonNavigation?.situationNavigation?.name ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Trim. maintenance:',
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
                        child: Text('\n${set.maintenanceNavigation?.trimestral.dateOnlyString ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Anual. maintenance:',
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
                        child: Text('\n${set.maintenanceNavigation?.anual.dateOnlyString ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 SCT:',
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
                        child: Text('\n${set.sctNavigation?.number ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\n\u2022 Plates \n',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    for(int cont = 0; cont < set.plates.length; cont++)
                    TextSpan(
                      text: '\n Plate ${cont+1}: ${set.plates[cont].identifier} - ${set.plates[cont].country}',
                    ),
                  ],
                ),
              ),
              onAccept: () async {
                List<CSMSetValidationResult> evaluation = set.evaluate();
                if (evaluation.isEmpty) {
                  final String auth = _sessionStorage.getTokenStrict();
                  MainResolver<RecordUpdateOut<Trailer>> resolverUpdateOut =
                      await Sources.foundationSource.trailers.update(set, auth);
                  try {
                    resolverUpdateOut
                        .act((JObject json) =>
                            RecordUpdateOut<Trailer>.des(json, Trailer.des))
                        .then(
                      (RecordUpdateOut<Trailer> updateOut) {
                        CSMRouter.i.pop();
                      },
                    );
                  } catch (x) {
                    debugPrint(x.toString());
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
            );
          },
        );
      },
      form: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CSMSpacingColumn(spacing: 20, children: <Widget>[
            TWSInputText(
              label: "Economic",
              hint: "enter a economic number",
              maxLength: 16,
              isStrictLength: true,
              controller: TextEditingController(
                  text: set.trailerCommonNavigation!.economic),
              onChanged: (String text) {
                set = set.clone(
                  trailerCommonNavigation:
                      set.trailerCommonNavigation!.clone(economic: text),
                );
              },
            ),
            TWSAutoCompleteField<Carrier>(
              width: double.maxFinite,
              label: "Carrier",
              hint: "Select a carrier",
              isOptional: true,
              adapter: const _CarriersViewAdapter(),
              initialValue: set.carrierNavigation,
              onChanged: (Carrier? selectedItem) {
                set.carrierNavigation = null;
                set = set.clone(
                  carrier: selectedItem?.id ?? 0,
                  carrierNavigation: selectedItem,
                );
              },
              displayValue: (Carrier? set) {
                return set?.name ?? 'error';
              },
            ),
            TWSAutoCompleteField<VehiculeModel>(
              width: double.maxFinite,
              label: "Model",
              hint: "Select a model",
              isOptional: true,
              adapter: const _VehiculeModelViewAdapter(),
              initialValue: set.vehiculeModelNavigation,
              onChanged: (VehiculeModel? selectedItem) {
                set.vehiculeModelNavigation = null;
                set = set.clone(
                  model: selectedItem?.id ?? 0,
                  vehiculeModelNavigation: selectedItem,
                );
              },
              displayValue: (VehiculeModel? set) {
                return set?.name ?? 'error';
              },
            ),
            TWSAutoCompleteField<TrailerType>(
              width: double.maxFinite,
              label: "Trailer Type",
              hint: "Select a trailer type",
              isOptional: true,
              adapter: const _TrailerTypeViewAdapter(),
              initialValue: set.trailerCommonNavigation?.trailerTypeNavigation,
              onChanged: (TrailerType? selectedItem) {
                set.trailerCommonNavigation?.trailerTypeNavigation = null;
                set = set.clone(
                  trailerCommonNavigation: set.trailerCommonNavigation?.clone(
                    trailerTypeNavigation: selectedItem,
                    type: selectedItem?.id ?? 0,
                  ),
                );
              },
              displayValue: (TrailerType? set) {
                return set != null
                    ? "${set.trailerClassNavigation?.name} - ${set.size}"
                    : "error";
              },
            ),
            TWSAutoCompleteField<Situation>(
              width: double.maxFinite,
              label: "Situation",
              hint: "Select a situation",
              isOptional: true,
              adapter: const _SituationsViewAdapter(),
              initialValue: set.trailerCommonNavigation?.situationNavigation,
              onChanged: (Situation? selectedItem) {
                set.trailerCommonNavigation!.situationNavigation = null;
                set = set.clone(
                  trailerCommonNavigation: set.trailerCommonNavigation?.clone(
                    situationNavigation: selectedItem,
                    situation: selectedItem?.id ?? 0,
                  ),
                );
              },
              displayValue: (Situation? set) {
                return set?.name ?? 'error';
              },
            ),
            TWSSection(
              title: "Plates",
              padding: const EdgeInsets.symmetric(horizontal: 15),
              content: TWSIncrementalList<Plate>(
                recordMin: 1,
                recordLimit: 2,
                modelBuilder: Plate.a,
                recordList: set.plates,
                onRemove: () {
                  set.plates.removeLast();
                },
                onAdd: (Plate model) {
                  set.plates.add(model);
                },
                recordBuilder: (Plate model, int index) {
                  return CSMSpacingColumn(spacing: 10, children: <Widget>[
                    TWSSectionDivider(
                      text: "Plate ${index + 1}",
                    ),
                    TWSInputText(
                      label: "Identifier",
                      hint: "enter the plate identifier",
                      maxLength: 12,
                      isStrictLength: false,
                      controller: TextEditingController(
                        text: set.plates[index].identifier,
                      ),
                      onChanged: (String text) {
                        set.plates[index] =
                            set.plates[index].clone(identifier: text);
                      },
                    ),
                    TWSAutoCompleteField<String>(
                      label: "Country",
                      width: double.maxFinite,
                      localList: TWSAMessages.kCountryList,
                      initialValue: set.plates[index].country,
                      displayValue: (String? value) => value ?? "error",
                      onChanged: (String? selection) {
                        set.plates[index] = set.plates[index].clone(
                          country: selection ?? "",
                          state: "",
                          trailer: set.id,
                        );
                        _platesFormsState();
                      },
                    ),
                    CSMDynamicWidget<_PlatesState>(
                      state: _platesState,
                      designer: (BuildContext ctx, _PlatesState state) {
                        final String usa = TWSAMessages.kCountryList[0];
                        final String mx = TWSAMessages.kCountryList[0];
                        final String country = set.plates[index].country == usa
                            ? usa
                            : set.plates[index].country == mx
                                ? mx
                                : "";
                        _platesFormsState = state.effect;
                        return TWSAutoCompleteField<String>(
                          label: "$country State",
                          width: double.maxFinite,
                          isEnabled: set.plates[index].country.isNotEmpty,
                          localList: set.plates[index].country == usa
                              ? TWSAMessages.kUStateCodes
                              : TWSAMessages.kMXStateCodes,
                          initialValue: set.plates[index].state,
                          isOptional: true,
                          displayValue: (String? value) => value ?? "error",
                          onChanged: (String? selection) {
                            set.plates[index] =
                                set.plates[index].clone(state: selection ?? "");
                          },
                        );
                      },
                    ),
                    TWSDatepicker(
                      width: double.maxFinite,
                      firstDate: DateTime(1999),
                      lastDate: DateTime(2040),
                      label: "Expiration",
                      controller: TextEditingController(
                          text: set.plates[index].expiration?.dateOnlyString),
                      onChanged: (String text) {
                        set.plates[index] = set.plates[index]
                            .clone(expiration: DateTime.tryParse(text));
                      },
                    ),
                  ]);
                },
              ),
            ),

            if(set.sctNavigation != null)
            TWSSection(
              title: "SCT",
              padding: const EdgeInsets.symmetric(horizontal: 15),
              content: CSMSpacingColumn(spacing: 10, children: <Widget>[
                TWSInputText(
                  label: "Type",
                  hint: "enter the SCT type",
                  maxLength: 6,
                  isStrictLength: true,
                  controller:
                      TextEditingController(text: set.sctNavigation?.type),
                  onChanged: (String text) {
                    set = set.clone(
                        sctNavigation: set.sctNavigation?.clone(type: text) ??
                            SCT.a().clone(type: text));
                  },
                ),
                TWSInputText(
                  label: "Number",
                  hint: "enter the SCT number",
                  maxLength: 25,
                  isStrictLength: true,
                  controller: TextEditingController(
                    text: set.sctNavigation?.number,
                  ),
                  onChanged: (String text) {
                    set = set.clone(
                        sctNavigation: set.sctNavigation?.clone(number: text) ??
                            SCT.a().clone(number: text));
                  },
                ),
                TWSInputText(
                  label: "Configuration",
                  hint: "enter the SCT configuration",
                  maxLength: 10,
                  isStrictLength: false,
                  controller: TextEditingController(
                    text: set.sctNavigation?.configuration,
                  ),
                  onChanged: (String text) {
                    set = set.clone(
                      sctNavigation:
                          set.sctNavigation?.clone(configuration: text) ??
                              SCT.a().clone(configuration: text),
                    );
                  },
                ),
              ]),
            ),

            if(set.sctNavigation == null) 
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TWSCascadeSection(
                title: "SCT", 
                padding: EdgeInsets.zero,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                onPressed: (bool isShowing) {
                  //Creates a new SCT object.
                  if(isShowing){
                    set = set.clone(
                      sctNavigation: SCT.a(),
                    );
                    return;
                  }
              
                  //Removing the SCT object.
                  set = set.clone(
                    sct: 0,
                  );
                },
                mainControl: const Expanded(
                  child: TWSDisplayFlat(
                    display: "Add an SCT",
                    color: TWSAColors.oceanBlue,
                    foreColor: TWSAColors.warmWhite,
                  ),
                ),
                content: CSMSpacingColumn(
                  spacing: 10,
                  children: <Widget>[
                    TWSInputText(
                      label: "Type",
                      hint: "enter the SCT type",
                      maxLength: 6,
                      isStrictLength: true,
                      controller:
                          TextEditingController(text: set.sctNavigation?.type),
                      onChanged: (String text) {
                        set = set.clone(
                            sctNavigation: set.sctNavigation?.clone(type: text) ??
                                SCT.a().clone(type: text));
                      },
                    ),
                    TWSInputText(
                      label: "Number",
                      hint: "enter the SCT number",
                      maxLength: 25,
                      isStrictLength: true,
                      controller: TextEditingController(
                        text: set.sctNavigation?.number,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                            sctNavigation: set.sctNavigation?.clone(number: text) ??
                                SCT.a().clone(number: text));
                      },
                    ),
                    TWSInputText(
                      label: "Configuration",
                      hint: "enter the SCT configuration",
                      maxLength: 10,
                      isStrictLength: false,
                      controller: TextEditingController(
                        text: set.sctNavigation?.configuration,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          sctNavigation:
                              set.sctNavigation?.clone(configuration: text) ??
                                  SCT.a().clone(configuration: text),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            if(set.maintenanceNavigation != null)
            TWSSection(
              title: "Maintenance",
              padding: const EdgeInsets.symmetric(horizontal: 15),
              content: CSMSpacingColumn(
                spacing: 20,
                children: <Widget>[
                  TWSDatepicker(
                    width: double.maxFinite,
                    firstDate: DateTime(1999),
                    lastDate: DateTime(2040),
                    label: "Trimestral",
                    controller: TextEditingController(
                      text:set.maintenanceNavigation?.trimestral.dateOnlyString,
                    ),
                    onChanged: (String text) {
                      set = set.clone(
                        maintenanceNavigation: set.maintenanceNavigation?.clone(
                          trimestral: DateTime.tryParse(text) ?? DateTime(0),
                        ) ??
                        Maintenance.a().clone(
                          trimestral: DateTime.tryParse(text) ?? DateTime(0),
                        ),
                      );
                    },
                  ),
                  TWSDatepicker(
                    width: double.maxFinite,
                    firstDate: DateTime(1999),
                    lastDate: DateTime(2040),
                    label: "Anual",
                    controller: TextEditingController(
                        text: set.maintenanceNavigation?.anual.dateOnlyString),
                    onChanged: (String text) {
                      set = set.clone(
                        maintenanceNavigation: set.maintenanceNavigation?.clone(
                          anual: DateTime.tryParse(text) ?? DateTime(0),
                        ) ??
                        Maintenance.a().clone(
                          anual: DateTime.tryParse(text) ?? DateTime(0),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            if(set.maintenanceNavigation == null) 
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TWSCascadeSection(
                title: "Maintenance", 
                padding: EdgeInsets.zero,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                onPressed: (bool isShowing) {
                  //Creates a new Maintenance object.
                  if(isShowing){
                    set = set.clone(
                      maintenanceNavigation: Maintenance.a(),
                    );
                    return;
                  }
              
                  //Removing the Maintenance object.
                  set = set.clone(
                    maintenance: 0,
                  );
                },
                mainControl: const Expanded(
                  child: TWSDisplayFlat(
                    display: "Add a Maintenance data",
                    color: TWSAColors.oceanBlue,
                    foreColor: TWSAColors.warmWhite,
                  ),
                ),
                content: CSMSpacingColumn(
                  spacing: 10,
                  children: <Widget>[
                    TWSDatepicker(
                    width: double.maxFinite,
                    firstDate: DateTime(1999),
                    lastDate: DateTime(2040),
                    label: "Trimestral",
                    controller: TextEditingController(
                      text:set.maintenanceNavigation?.trimestral.dateOnlyString,
                    ),
                    onChanged: (String text) {
                      set = set.clone(
                        maintenanceNavigation: set.maintenanceNavigation?.clone(
                          trimestral: DateTime.tryParse(text) ?? DateTime(0),
                        ) ??
                        Maintenance.a().clone(
                          trimestral: DateTime.tryParse(text) ?? DateTime(0),
                        ),
                      );
                    },
                  ),
                  TWSDatepicker(
                    width: double.maxFinite,
                    firstDate: DateTime(1999),
                    lastDate: DateTime(2040),
                    label: "Anual",
                    controller: TextEditingController(
                        text: set.maintenanceNavigation?.anual.dateOnlyString),
                    onChanged: (String text) {
                      set = set.clone(
                        maintenanceNavigation: set.maintenanceNavigation?.clone(
                          anual: DateTime.tryParse(text) ?? DateTime(0),
                        ) ??
                        Maintenance.a().clone(
                          anual: DateTime.tryParse(text) ?? DateTime(0),
                        ),
                      );
                    },
                  ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget composeViewer(Trailer set, BuildContext context) {
    return SizedBox.expand(
      child: CSMSpacingColumn(
        spacing: 12,
        crossAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TWSPropertyViewer(
            label: 'Economic',
            value: set.trailerCommonNavigation?.economic ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Type',
            value: set.trailerCommonNavigation?.trailerTypeNavigation?.trailerClassNavigation?.name != null? 
              '${set.trailerCommonNavigation?.trailerTypeNavigation?.trailerClassNavigation?.name} - ${set.trailerCommonNavigation?.trailerTypeNavigation?.size}': "---",
          ),
          TWSPropertyViewer(
            label: 'Manufacturer',
            value: set.vehiculeModelNavigation?.manufacturerNavigation?.name ?? '---',
          ),
          TWSPropertyViewer(
            label: 'SCT number',
            value: set.sctNavigation?.number ?? '---',
          ),
          TWSPropertyViewer(
            label: 'USDOT number',
            value: set.carrierNavigation?.usdotNavigation?.scac ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Trimestral Maintenance',
            value:
                set.maintenanceNavigation?.trimestral.dateOnlyString ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Anual Maintenance',
            value: set.maintenanceNavigation?.anual.dateOnlyString ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Situation',
            value:
                set.trailerCommonNavigation?.situationNavigation?.name ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Location',
            value: set.trailerCommonNavigation?.locationNavigation?.name ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Plates',
            value: getPlates(set),
          ),
        ],
      ),
    );
  }
}
