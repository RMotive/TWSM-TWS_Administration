part of '../locations_article.dart';
final SessionStorage _sessionStorage = SessionStorage.i;
const List<String> _countryOptions = TWSAMessages.kCountryList;
const List<String> _usaStateOptions = TWSAMessages.kUStateCodes;
const List<String> _mxStateOptions = TWSAMessages.kMXStateCodes;
class _AddresState extends CSMStateBase {}
_AddresState _addresState = _AddresState();

class _AddressCreationState extends CSMStateBase { }
final _AddressCreationState _addressState = _AddressCreationState();
void Function() _addressEffect = () {};

final class _DialogState extends CSMStateBase {}
final _DialogState _dialogState = _DialogState();
void Function() _dialogEffect = (){};


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

class _WaypointState extends CSMStateBase {
  //stores the lastest record opened, due the editing controller preserve the text state when select another record.
  int lastestRecordID = 0;
  TextEditingController longitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController altitudeController = TextEditingController();

}
_WaypointState _waypointState = _WaypointState();


final class _TableAdapter extends TWSArticleTableAdapter<Location> {
  final _LocationssArticleState state;
  const _TableAdapter(this.state);

 @override
  Future<SetViewOut<Location>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<Location> options = SetViewOptions<Location>(false, range, page, null, orderings, state.locationsFilters);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<Location>> resolver = await Sources.foundationSource.locations.view(options, auth);

    SetViewOut<Location> view = await resolver.act((JObject json) => SetViewOut<Location>.des(json, Location.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('locations-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }

  @override
  TWSArticleTableEditor? composeEditor(Location set, void Function() closeReinvoke, BuildContext context) {
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
                  title: 'Location update confirmation',
                  onAccept: () async {
                    List<CSMSetValidationResult> evaluation = set.evaluate();
                    if (evaluation.isEmpty) {
                      final String auth = _sessionStorage.getTokenStrict();
                      MainResolver<RecordUpdateOut<Location>> resolverUpdateOut =
                          await Sources.foundationSource.locations.update(set, auth);
                      try {
                        resolverUpdateOut
                            .act((JObject json) =>
                                RecordUpdateOut<Location>.des(json, Location.des))
                            .then(
                          (RecordUpdateOut<Location> updateOut) {
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
                          text: '\n\u2022 Country:',
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
                            child: Text('\n${set.addressNavigation?.country ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 State:',
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
                            child: Text('\n${set.addressNavigation?.state ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 City:',
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
                            child: Text('\n${set.addressNavigation?.city ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Street:',
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
                            child: Text('\n${set.addressNavigation?.street ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 ZIP:',
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
                            child: Text('\n${set.addressNavigation?.zip ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Colonia:',
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
                            child: Text('\n${set.addressNavigation?.colonia ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Longitude:',
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
                            child: Text('\n${set.waypointNavigation?.longitude ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Latitude:',
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
                            child: Text('\n${set.waypointNavigation?.latitude ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Altitude:',
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
                            child: Text('\n${set.waypointNavigation?.altitude ?? "---"}'),
                          ),
                        ),
                      ]
                    )
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
                maxLength: 30,
                controller: TextEditingController(
                  text: set.name,
                ),
                onChanged: (String text) {
                  set.name = text;
                },
              ),

             if(set.addressNavigation != null)
              TWSSection(
                padding: const EdgeInsets.symmetric(vertical: 10),
                title: 'Address', 
                content: CSMSpacingColumn(
                  spacing: 10,
                  children: <Widget>[
                    TWSAutoCompleteField<String>(
                      width: double.maxFinite,
                      label: 'Country',
                      isOptional: true,
                      localList: _countryOptions,
                      initialValue: set.addressNavigation?.country == "" ? null :  set.addressNavigation?.country,
                      displayValue:(String? item) => item ?? "Not valid data",
                      onChanged: (String? text) {
                        set = set.clone(
                          addressNavigation: set.addressNavigation?.clone(
                              country: text ?? '',
                              state: '',
                            ) ?? Address.a().clone(
                              country: text ?? '',
                              state: '',
                            ),
                        );
                        _addressEffect();                        
                      },
                    ),
                    CSMDynamicWidget<_AddresState>(
                      state: _addresState, 
                      designer: (BuildContext ctx, _AddresState state) {
                        String? currentCountry = set.addressNavigation?.country;
                        final String country = set.addressNavigation?.country == _countryOptions[0]
                            ? _countryOptions[0]
                            : set.addressNavigation?.country == _countryOptions[1]
                                ? _countryOptions[1]
                                : "";
                        _addressEffect = state.effect;
                        return TWSAutoCompleteField<String>(
                          width: double.maxFinite,
                          label: '$country State',
                          suffixLabel: ' opt.',
                          isOptional: true,
                          isEnabled: currentCountry == _countryOptions[0] || currentCountry == _countryOptions[1],
                          localList: country == _countryOptions[0]? _usaStateOptions : _mxStateOptions,
                          initialValue: set.addressNavigation?.state == "" ? null : set.addressNavigation?.state,
                          displayValue:(String? item) => item ?? "Not valid data",
                          onChanged: (String? text) {
                            set = set.clone(
                              addressNavigation: set.addressNavigation?.clone(
                                state: text ?? '',
                              ) ?? Address.a().clone(
                                state: text ?? '',
                              ),
                            );
                          },
                        );
                      },
                    ),
                    
                    TWSInputText(
                      label: "Street",
                      hint: "Enter an street",
                      suffixLabel: ' opt.',
                      maxLength: 100,
                      controller: TextEditingController(
                        text: set.addressNavigation?.street,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          addressNavigation: set.addressNavigation?.clone(
                            street: text,
                          ) ?? Address.a().clone(
                            street: text,
                          ),
                        );
                      },
                    ),
                    TWSInputText(
                      label: "Alt. street",
                      hint: "Enter an alt. street",
                      suffixLabel: ' opt.',
                      maxLength: 100,
                      controller: TextEditingController(
                        text: set.addressNavigation?.altStreet,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          addressNavigation: set.addressNavigation?.clone(
                            altStreet: text,
                          ) ?? Address.a().clone(
                            altStreet: text,
                          ),
                        );
                      },
                    ),
                    TWSInputText(
                      label: "City",
                      hint: "Enter a city",
                      suffixLabel: ' opt.',
                      maxLength: 30,
                      controller: TextEditingController(
                        text: set.addressNavigation?.city,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          addressNavigation: set.addressNavigation?.clone(
                            city: text,
                          ) ?? Address.a().clone(
                            city: text,
                          ),
                        );
                      },
                    ),
                    TWSInputText(
                      label: "ZIP",
                      hint: "Enter a ZIP number",
                      suffixLabel: ' opt.',
                      maxLength: 5,
                      controller: TextEditingController(
                        text: set.addressNavigation?.zip,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          addressNavigation: set.addressNavigation?.clone(
                              zip: text,
                            ) ?? Address.a().clone(
                              zip: text,
                            ),
                        );
                      },
                    ),
                    TWSInputText(
                      label: "Colonia",
                      hint: "Enter a colonia",
                      suffixLabel: ' opt.',
                      maxLength: 100,
                      controller: TextEditingController(
                        text: set.addressNavigation?.colonia,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          addressNavigation: set.addressNavigation?.clone(
                            colonia: text,
                          ) ?? Address.a().clone(
                            colonia: text,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              /// build a creation form.
              if(set.addressNavigation == null) 
              CSMDynamicWidget<_AddressCreationState>(
                state: _addressState,
                designer: (BuildContext context, _AddressCreationState state) {
                  final bool isEnable = set.addressNavigation?.id == 0 ||
                        set.addressNavigation?.id == null;
                  return TWSCascadeSection(
                    title: "Address",
                    onPressed: (bool isShowing) {
                      //Creates a new address object.
                      set = set.clone(
                        addressNavigation: isShowing? Address.a() : null,
                        address: 0
                      );
                      state.effect();
                    },
                    mainControl: Expanded(
                      child: TWSAutoCompleteField<Address>(
                        label: 'Select an address',
                        isEnabled: isEnable,
                        isOptional: true,
                        adapter: const _AddressesViewAdapter(),
                        initialValue: set.addressNavigation,
                        hasKeyValue: (Address? item) {
                          if (item?.id != null) return item!.id > 0;
                          return false;
                        },
                        displayValue: (Address? item) {
                          return item != null
                              ? "${item.country}/${item.city ?? "-"}/${item.zip ?? "-"}/${item.colonia ?? "-"}/${item.street ?? "-"}"
                              : "Unexpected value";
                        },
                        onChanged: (Address? value) {
                          set = set.clone(
                            address: value?.id ?? 0,
                            addressNavigation:  value,
                          );
                          state.effect();
                        },
                      ),
                    ),
                    content: CSMSpacingColumn(
                      spacing: 10,
                      children: <Widget>[
                        const TWSSectionDivider(
                          color: Colors.white,
                          text: "Create an Address",
                        ),
                        TWSAutoCompleteField<String>(
                          isEnabled: isEnable,
                          width: double.maxFinite,
                          localList: _countryOptions,
                          initialValue: set.addressNavigation?.country == "" ? null :  set.addressNavigation?.country,
                          displayValue:(String? item) => item ?? "Not valid data",
                          label: 'Country',
                          isOptional: true,
                          onChanged: (String? text) {
                            set = set.clone(
                                addressNavigation:
                                    set.addressNavigation?.clone(
                                          country: text ?? '',
                                          state: '',
                                        ) ??
                                        Address.a().clone(
                                          country: text ?? '',
                                          state: '',
                                        ),
                              );
                            _addressEffect(); 
                          },
                        ),
                        CSMDynamicWidget<_AddresState>(
                          state: _addresState, 
                          designer: (BuildContext ctx, _AddresState state) {
                            String? currentCountry = set.addressNavigation?.country;
                            final String country = set.addressNavigation?.country == _countryOptions[0]
                                ? _countryOptions[0]
                                : set.addressNavigation?.country == _countryOptions[1]
                                    ? _countryOptions[1]
                                    : "";
                            _addressEffect = state.effect;
                            return TWSAutoCompleteField<String>(
                              width: double.maxFinite,
                              label: '$country State',
                              suffixLabel: ' opt.',
                              isOptional: true,
                              isEnabled: currentCountry == _countryOptions[0] || currentCountry == _countryOptions[1],
                              localList: country == _countryOptions[0]? _usaStateOptions : _mxStateOptions,
                              initialValue: set.addressNavigation?.state == "" ? null : set.addressNavigation?.state,
                              displayValue:(String? item) => item ?? "Not valid data",
                              onChanged: (String? text) {
                                set = set.clone(
                                  addressNavigation: set.addressNavigation?.clone(
                                    state: text ?? '',
                                  ) ?? Address.a().clone(
                                    state: text ?? '',
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        TWSInputText(
                          label: "Street",
                          hint: "Enter an street",
                          suffixLabel: ' opt.',
                          maxLength: 100,
                          controller: TextEditingController(
                            text: set.addressNavigation?.street,
                          ),
                          onChanged: (String text) {
                            set = set.clone(
                              addressNavigation: set.addressNavigation?.clone(
                                street: text,
                              ) ?? Address.a().clone(
                                street: text,
                              ),
                            );
                          },
                        ),
                        TWSInputText(
                          label: "Alt. street",
                          hint: "Enter an alt. street",
                          suffixLabel: ' opt.',
                          maxLength: 100,
                          controller: TextEditingController(
                            text: set.addressNavigation?.altStreet,
                          ),
                          onChanged: (String text) {
                            set = set.clone(
                              addressNavigation: set.addressNavigation?.clone(
                                altStreet: text,
                              ) ?? Address.a().clone(
                                altStreet: text,
                              ),
                            );
                          },
                        ),
                        TWSInputText(
                          label: "City",
                          hint: "Enter a city",
                          suffixLabel: ' opt.',
                          maxLength: 30,
                          controller: TextEditingController(
                            text: set.addressNavigation?.city,
                          ),
                          onChanged: (String text) {
                            set = set.clone(
                              addressNavigation: set.addressNavigation?.clone(
                                city: text,
                              ) ?? Address.a().clone(
                                city: text,
                              ),
                            );
                          },
                        ),
                        TWSInputText(
                          label: "ZIP",
                          hint: "Enter a ZIP number",
                          suffixLabel: ' opt.',
                          maxLength: 5,
                          controller: TextEditingController(
                            text: set.addressNavigation?.zip,
                          ),
                          onChanged: (String text) {
                            set = set.clone(
                              addressNavigation: set.addressNavigation?.clone(
                                zip: text,
                              ) ?? Address.a().clone(
                                zip: text,
                              ),
                            );
                          },
                        ),
                        TWSInputText(
                          label: "Colonia",
                          hint: "Enter a colonia",
                          suffixLabel: ' opt.',
                          maxLength: 100,
                          controller: TextEditingController(
                            text: set.addressNavigation?.colonia,
                          ),
                          onChanged: (String text) {
                            set = set.clone(
                              addressNavigation: set.addressNavigation?.clone(
                                colonia: text,
                              ) ?? Address.a().clone(
                                colonia: text,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
    
              if(set.waypointNavigation != null)
              TWSSection(
                title: 'Waypoint cords', 
                content: CSMDynamicWidget<_WaypointState>(
                  state: _waypointState, 
                  designer: (BuildContext ctx, _WaypointState state) {
                    // Set an initial value for the TWSInputText.
                    if(state.lastestRecordID != set.id){
                      state.lastestRecordID = set.id;
                      state.longitudeController.text = set.waypointNavigation?.longitude.toString() ?? "";
                      state.latitudeController.text = set.waypointNavigation?.latitude.toString() ?? "";
                      state.altitudeController.text = set.waypointNavigation?.altitude != null? set.waypointNavigation?.altitude.toString() ?? "" : "";
                    }
                    
                    return CSMSpacingColumn(
                      spacing: 10,
                      children: <Widget>[
                        TWSInputText(
                          label: "Longitude",
                          hint: "Add longitude cord.",
                          maxLength: 11,
                          keyboardType: TextInputType.number,
                          showErrorColor: !(set.waypointNavigation?.longitude.toString() ?? "").evaluateAsDecimal(),
                          controller: state.longitudeController,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                          ],
                          onChanged: (String text) {
                            set = set.clone(
                              waypointNavigation: set.waypointNavigation?.clone(
                                longitude: double.tryParse(text) ?? 0.0,
                              ) ?? Waypoint.a().clone(
                                longitude: double.tryParse(text) ?? 0.0,
                              ),
                            );
                            state.effect();
                          },
                        ),
                        TWSInputText(
                          label: "Latitude",
                          hint: "Add latitude cord.",
                          maxLength: 11,
                          keyboardType: TextInputType.number,
                          showErrorColor: !(set.waypointNavigation?.latitude.toString() ?? "").evaluateAsDecimal(),
                          controller: state.latitudeController,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                          ],
                          onChanged: (String text) {
                            set = set.clone(
                              waypointNavigation: set.waypointNavigation?.clone(
                                latitude: double.tryParse(text) ?? 0.0,
                              ) ?? Waypoint.a().clone(
                                latitude: double.tryParse(text) ?? 0.0,
                              ),
                            );
                            state.effect();
                          },
                        ),
                        TWSInputText(
                          label: "Altitude",
                          hint: "Add Altitude cord.",
                          maxLength: 11,
                          keyboardType: TextInputType.number,
                          showErrorColor: set.waypointNavigation?.altitude != null? !(set.waypointNavigation?.altitude.toString() ?? "").evaluateAsDecimal() : false,
                          controller: state.altitudeController,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                          ],
                          onChanged: (String text) {
                            set = set.clone(
                              waypointNavigation: set.waypointNavigation?.clone(
                                altitude: double.tryParse(text) ?? 0.0,
                              ) ?? Waypoint.a().clone(
                                altitude: double.tryParse(text) ?? 0.0,
                              ),
                            );
                            state.effect();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// build a creation form.
              if(set.waypointNavigation == null) 
              TWSCascadeSection(
                title: "Waypoint", 
                padding: const EdgeInsets.symmetric(vertical: 10),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                onPressed: (bool isShowing) {
                  //Creates a new waypoint object.
                  set = set.clone(
                    waypointNavigation: isShowing? Waypoint.a() : null,
                    waypoint: !isShowing? 0 : null,
                  );
                  

                },
                mainControl: const Expanded(
                  child: TWSDisplayFlat(
                    display: "Add a Waypoint",
                    color: TWSAColors.oceanBlue,
                    foreColor: TWSAColors.warmWhite,
                  ),
                ),
                content: CSMDynamicWidget<_WaypointState>(
                  state: _waypointState, 
                  designer:(BuildContext ctx, _WaypointState state) {
                    // Set an initial value for the TWSInputText.
                    if(state.lastestRecordID != set.id){
                      state.lastestRecordID = set.id;
                      state.longitudeController.text = set.waypointNavigation?.longitude.toString() !='0'? set.waypointNavigation?.longitude.toString() ?? "" : "";
                      state.latitudeController.text = set.waypointNavigation?.longitude.toString() != '0'? set.waypointNavigation?.latitude.toString() ?? "" : "";
                      state.altitudeController.text = set.waypointNavigation?.altitude != null? set.waypointNavigation?.altitude.toString() ?? "" : "";
                    }
                    return CSMSpacingColumn(
                      spacing: 10,
                      children: <Widget>[
                        TWSInputText(
                          label: "Longitude",
                          hint: "Add longitude cord.",
                          maxLength: 11,
                          keyboardType: TextInputType.number,
                          showErrorColor: !(set.waypointNavigation?.longitude.toString() ?? "0.0").evaluateAsDecimal(),
                          controller: state.longitudeController,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                          ],
                          onChanged: (String text) {
                            set = set.clone(
                              waypointNavigation: set.waypointNavigation?.clone(
                                longitude: double.tryParse(text) ?? 0.0,
                              ) ?? Waypoint.a().clone(
                                longitude: double.tryParse(text) ?? 0.0,
                              ),
                            );
                            state.effect();
                          },
                        ),
                        TWSInputText(
                          label: "Latitude",
                          hint: "Add latitude cord.",
                          maxLength: 11,
                          keyboardType: TextInputType.number,
                          showErrorColor: !(set.waypointNavigation?.latitude.toString() ?? "0.0").evaluateAsDecimal(),
                          controller: state.latitudeController,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                          ],
                          onChanged: (String text) {
                            set = set.clone(
                              waypointNavigation: set.waypointNavigation?.clone(
                                latitude: double.tryParse(text) ?? 0.0,
                              ) ?? Waypoint.a().clone(
                                latitude: double.tryParse(text) ?? 0.0,
                              ),
                            );
                            state.effect();
                          },
                        ),
                        TWSInputText(
                          label: "Altitude",
                          hint: "Add Altitude cord.",
                          maxLength: 11,
                          keyboardType: TextInputType.number,
                          showErrorColor: set.waypointNavigation?.altitude != null? !(set.waypointNavigation?.altitude.toString() ?? "").evaluateAsDecimal() : false,
                          controller: state.altitudeController,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                          ],
                          onChanged: (String text) {
                            set = set.clone(
                              waypointNavigation: set.waypointNavigation?.clone(
                                altitude: double.tryParse(text) ?? 0.0,
                              ) ?? Waypoint.a().clone(
                                altitude: double.tryParse(text) ?? 0.0,
                              ),
                            );
                            state.effect();
                          },
                        ),
                      ],
                    );
                  },
                )
              ),

            ],
          ),
        ),
      ), 

    );
  }
  
  @override
  Widget? composeViewer(Location set, BuildContext context) {
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
              label: "Country",
              value: set.addressNavigation?.country ?? "---",
            ),
            TWSPropertyViewer(
              label: "State",
              value: set.addressNavigation?.state ?? "---",
            ),
            TWSPropertyViewer(
              label: "City",
              value: set.addressNavigation?.city ?? "---",
            ),
            TWSPropertyViewer(
              label: "Street",
              value: set.addressNavigation?.street ?? "---",
            ),
            TWSPropertyViewer(
              label: "Alt. Street",
              value: set.addressNavigation?.altStreet ?? "---",
            ),
            TWSPropertyViewer(
              label: "ZIP",
              value: set.addressNavigation?.zip ?? "---",
            ),
            TWSPropertyViewer(
              label: "Colonia",
              value: set.addressNavigation?.colonia ?? "---",
            ),
            TWSPropertyViewer(
              label: "Longitude",
              value: set.waypointNavigation?.longitude.toString() ?? "---",
            ),
            TWSPropertyViewer(
              label: "Latitude",
              value: set.waypointNavigation?.latitude.toString() ?? "---",
            ),
            TWSPropertyViewer(
              label: "Altitude",
              value: set.waypointNavigation?.altitude?.toString() ?? "---",
            ),
          ],
        ),
      ),
    );
  }
}
