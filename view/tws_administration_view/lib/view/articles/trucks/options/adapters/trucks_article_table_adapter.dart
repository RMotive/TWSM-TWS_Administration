part of '../../trucks_article.dart';

// This document stores all consume classes for Truck table and update options.

final SessionStorage _sessionStorage = SessionStorage.i;

class _PlatesState extends CSMStateBase{}
final _PlatesState _platesState = _PlatesState();
void Function() _platesFormsState = (){};

class _DialogState extends CSMStateBase{}
final _DialogState _dialogState = _DialogState();
void Function() _dialogEffect = (){};

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

/// [_TableAdapter] class stores consumes the data and all the compose components for the table [TruckExternal] table.
final class _TableAdapter extends TWSArticleTableAdapter<Truck> {
  final _TrucksArticleState state;
  const _TableAdapter(this.state);

  String getPlates(Truck item){
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
  Future<SetViewOut<Truck>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<Truck> options = SetViewOptions<Truck>(false, range, page, null, orderings, state.trucksFilters);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<Truck>> resolver = await Sources.foundationSource.trucks.view(options, auth);

    SetViewOut<Truck> view = await resolver.act((JObject json) => SetViewOut<Truck>.des(json, Truck.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('truck-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }
  
  @override
  TWSArticleTableEditor? composeEditor(Truck set, Function closeReinvoke, BuildContext context) {
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
          builder: (BuildContext context) {
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
                  title: 'Truck update confirmation',
                  statement: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'Are you sure you want to update a truck?',
                      children: <InlineSpan>[
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
                            child: Text('\n${set.truckCommonNavigation?.economic ?? "---"}'),
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
                          text: '\n\u2022 Manufacturer:',
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
                            child: Text('\n${set.vehiculeModelNavigation?.manufacturerNavigation?.name ?? "---"}'),
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
                          text: '\n\u2022 USDOT:',
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
                            child: Text('\n scac - ${set.carrierNavigation?.usdotNavigation?.scac ?? "---"}'),
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
                            child: Text('\n ${set.maintenanceNavigation?.trimestral.dateOnlyString ?? "---"}'),
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
                            child: Text('\n ${set.maintenanceNavigation?.anual.dateOnlyString ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Situation',
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
                            child: Text('\n ${set.truckCommonNavigation?.situationNavigation?.name ?? "---"}'),
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
                      MainResolver<RecordUpdateOut<Truck>> resolverUpdateOut =
                          await Sources.foundationSource.trucks.update(set, auth);
                      try {
                        resolverUpdateOut
                            .act((JObject json) =>
                                RecordUpdateOut<Truck>.des(json, Truck.des))
                            .then(
                          (RecordUpdateOut<Truck> updateOut) {
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
                );
              },
            );
          },
        );
      },
      form: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CSMSpacingColumn(spacing: 10, children: <Widget>[
            TWSInputText(
              label: "VIN",
              hint: "enter a vin number",
              maxLength: 17,
              isStrictLength: true,
              controller: TextEditingController(text: set.vin),
              onChanged: (String text) {
                set = set.clone(vin: text);
              },
            ),
            TWSInputText(
              label: "Motor",
              hint: "enter a motor number",
              maxLength: 16,
              isStrictLength: true,
              controller: TextEditingController(text: set.motor),
              onChanged: (String text) {
                set = set.clone(motor: text);
              },
            ),
            TWSInputText(
              label: "Economic",
              hint: "enter a economic number",
              maxLength: 16,
              isStrictLength: true,
              controller: TextEditingController(
                  text: set.truckCommonNavigation!.economic),
              onChanged: (String text) {
                set = set.clone(
                    truckCommonNavigation:
                        set.truckCommonNavigation!.clone(economic: text));
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
                }),
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
                }),
            TWSAutoCompleteField<Situation>(
                width: double.maxFinite,
                label: "Situation",
                hint: "Select a situation",
                isOptional: true,
                adapter: const _SituationsViewAdapter(),
                initialValue: set.truckCommonNavigation?.situationNavigation,
                onChanged: (Situation? selectedItem) {
                  set.truckCommonNavigation!.situationNavigation = null;
                  set = set.clone(
                    truckCommonNavigation: set.truckCommonNavigation?.clone(
                      situation: selectedItem?.id ?? 0,
                      situationNavigation: selectedItem,
                    ),
                  );
                },
                displayValue: (Situation? set) {
                  return set?.name ?? 'error';
                }),
            TWSSection(
              title: "Plates",
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
                          text: set.plates[index].identifier),
                      onChanged: (String text) {
                        set.plates[index] =
                            set.plates[index].clone(identifier: text);
                      },
                    ),
                    TWSAutoCompleteField<String>(
                      label: "Country",
                      width: double.maxFinite,
                      localList: TWSAMessages.kCountryList,
                      isOptional: true,
                      initialValue: set.plates[index].country,
                      displayValue: (String? value) => value ?? "error",
                      onChanged: (String? selection) {
                        set.plates[index] = set.plates[index].clone(
                            country: selection ?? "", state: "", truck: set.id);
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
                  controller:
                      TextEditingController(text: set.sctNavigation?.number),
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
                      text: set.sctNavigation?.configuration),
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
                      controller:
                          TextEditingController(text: set.sctNavigation?.number),
                      onChanged: (String text) {
                        set = set.clone(
                            sctNavigation: set.sctNavigation?.clone(number: text) ??
                                SCT.a().clone(number: text),
                        );
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
              content: CSMSpacingColumn(
                spacing: 20,
                children: <Widget>[
                  TWSDatepicker(
                    width: double.maxFinite,
                    firstDate: DateTime(1999),
                    lastDate: DateTime(2040),
                    label: "Trimestral",
                    controller: TextEditingController(text: set.maintenanceNavigation?.trimestral.dateOnlyString),
                    onChanged: (String text) {
                      set = set.clone(
                        maintenanceNavigation: set.maintenanceNavigation?.clone(trimestral: DateTime.tryParse(text) ?? DateTime(0)) 
                        ?? Maintenance.a().clone(trimestral:DateTime.tryParse(text) ?? DateTime(0))
                      );
                    },
                  ),
                  TWSDatepicker(
                    width: double.maxFinite,
                    firstDate: DateTime(1999),
                    lastDate: DateTime(2040),
                    label: "Anual",
                    controller: TextEditingController(text: set.maintenanceNavigation?.anual.dateOnlyString),
                    onChanged: (String text) {
                      set = set.clone(
                          maintenanceNavigation: set.maintenanceNavigation?.clone(anual: DateTime.tryParse(text) ??DateTime(0)) 
                          ?? Maintenance.a().clone( anual: DateTime.tryParse(text) ?? DateTime(0))
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
                    display: "Add Maintenance",
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
                      controller: TextEditingController(text: set.maintenanceNavigation?.trimestral.dateOnlyString),
                      onChanged: (String text) {
                        set = set.clone(
                          maintenanceNavigation: set.maintenanceNavigation?.clone(trimestral: DateTime.tryParse(text) ?? DateTime(0)) 
                          ?? Maintenance.a().clone(trimestral:DateTime.tryParse(text) ?? DateTime(0))
                        );
                      },
                    ),
                    TWSDatepicker(
                      width: double.maxFinite,
                      firstDate: DateTime(1999),
                      lastDate: DateTime(2040),
                      label: "Anual",
                      controller: TextEditingController(text: set.maintenanceNavigation?.anual.dateOnlyString),
                      onChanged: (String text) {
                        set = set.clone(
                            maintenanceNavigation: set.maintenanceNavigation?.clone(anual: DateTime.tryParse(text) ??DateTime(0)) 
                            ?? Maintenance.a().clone( anual: DateTime.tryParse(text) ?? DateTime(0))
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            if(set.insuranceNavigation != null)
            TWSSection(
              title: "Insurance",
              content: CSMSpacingColumn(spacing: 10, children: <Widget>[
                TWSInputText(
                  label: "Policy",
                  hint: "enter the Insurance policy",
                  maxLength: 20,
                  isStrictLength: true,
                  controller: TextEditingController(
                      text: set.insuranceNavigation?.policy),
                  onChanged: (String text) {
                    set = set.clone(
                      insuranceNavigation: set.insuranceNavigation?.clone(policy: text) 
                      ?? Insurance.a().clone(policy: text)
                    );
                  },
                ),
                TWSDatepicker(
                  width: double.maxFinite,
                  firstDate: DateTime(1999),
                  lastDate: DateTime(2040),
                  label: "Expiration",
                  controller: TextEditingController(
                      text: set.insuranceNavigation?.expiration.dateOnlyString),
                  onChanged: (String text) {
                    set = set.clone(
                      insuranceNavigation: set.insuranceNavigation?.clone(expiration: DateTime.tryParse(text)) 
                      ?? Insurance.a().clone(expiration: DateTime.tryParse(text))
                    );
                  },
                ),
                TWSAutoCompleteField<String>(
                  label: "Country",
                  width: double.maxFinite,
                  localList: TWSAMessages.kCountryList,
                  initialValue: set.insuranceNavigation?.country,
                  displayValue: (String? value) => value ?? "error",
                  onChanged: (String? selection) {
                    set = set.clone(insuranceNavigation: set.insuranceNavigation?.clone(country: selection ?? "") 
                    ?? Insurance.a().clone(country: selection ?? ""));
                  },
                ),
              ]),
            ),
            
            if(set.insuranceNavigation == null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TWSCascadeSection(
                title: "Insurance", 
                padding: EdgeInsets.zero,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                onPressed: (bool isShowing) {
                  //Creates a new Insurance object.
                  if(isShowing){
                    set = set.clone(
                      insuranceNavigation: Insurance.a(),
                    );
                    return;
                  }
              
                  //Removing the Insurance object.
                  set = set.clone(
                    insurance: 0,
                  );
                },
                mainControl: const Expanded(
                  child: TWSDisplayFlat(
                    display: "Add Insurance",
                    color: TWSAColors.oceanBlue,
                    foreColor: TWSAColors.warmWhite,
                  ),
                ),
                content: CSMSpacingColumn(
                  spacing: 10,
                  children: <Widget>[
                    TWSInputText(
                      label: "Policy",
                      hint: "enter the Insurance policy",
                      maxLength: 20,
                      isStrictLength: true,
                      controller: TextEditingController(
                        text: set.insuranceNavigation?.policy,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          insuranceNavigation: set.insuranceNavigation?.clone(policy: text) 
                          ?? Insurance.a().clone(policy: text)
                        );
                      },
                    ),
                    TWSDatepicker(
                      width: double.maxFinite,
                      firstDate: DateTime(1999),
                      lastDate: DateTime(2040),
                      label: "Expiration",
                      controller: TextEditingController(
                          text: set.insuranceNavigation?.expiration.dateOnlyString),
                      onChanged: (String text) {
                        set = set.clone(
                          insuranceNavigation: set.insuranceNavigation?.clone(expiration: DateTime.tryParse(text)) 
                          ?? Insurance.a().clone(expiration: DateTime.tryParse(text))
                        );
                      },
                    ),
                    TWSAutoCompleteField<String>(
                      label: "Country",
                      width: double.maxFinite,
                      localList: TWSAMessages.kCountryList,
                      initialValue: set.insuranceNavigation?.country,
                      displayValue: (String? value) => value ?? "error",
                      onChanged: (String? selection) {
                        set = set.clone(insuranceNavigation: set.insuranceNavigation?.clone(country: selection ?? "") 
                        ?? Insurance.a().clone(country: selection ?? ""));
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
  Widget composeViewer(Truck set, BuildContext context) {
    return SizedBox.expand(
      child: CSMSpacingColumn(
        spacing: 12,
        crossAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TWSPropertyViewer(
            label: 'Economic',
            value: set.truckCommonNavigation?.economic ?? '---',
          ),
          TWSPropertyViewer(
            label: 'VIN',
            value: set.vin,
          ),
          TWSPropertyViewer(
            label: 'Carrier',
            value: set.carrierNavigation?.name ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Manufacturer',
            value: set.vehiculeModelNavigation?.manufacturerNavigation?.name ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Motor',
            value: set.motor ?? '---',
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
                set.truckCommonNavigation?.situationNavigation?.name ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Insurance',
            value:
                set.insuranceNavigation?.policy ?? '---',
          ),
          TWSPropertyViewer(
            label: 'Location',
            value: set.truckCommonNavigation?.locationNavigation?.name ?? '---',
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
