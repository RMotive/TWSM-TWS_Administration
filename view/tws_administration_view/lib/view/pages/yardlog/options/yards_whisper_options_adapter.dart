part of '../yardlog_page.dart';

final SessionStorage _sessionStorage = SessionStorage.i;
final TWSFoundationSource source = Sources.foundationSource;

final class _EntryState extends CSMStateBase {}
final _EntryState _entryState = _EntryState();

final class _LoadTypeState extends CSMStateBase {}
final _LoadTypeState _loadTypeState = _LoadTypeState();

final class _DamageState extends CSMStateBase {}
final _DamageState _damageState = _DamageState();

final class _SealsState extends CSMStateBase {}
final _SealsState _sealsState = _SealsState();
void Function() _sealsEffect = (){};

final class _TrailerState extends CSMStateBase {}
final _TrailerState _trailerState = _TrailerState();
void Function() _trailerEffect = (){};

final class _SectionState extends CSMStateBase {}
final _SectionState _sectionState = _SectionState();
void Function() _sectionEffect = (){};

final class _DialogState extends CSMStateBase {}
final _DialogState _dialogState = _DialogState();
void Function() _dialogEffect = (){};


final class _TableAdapter extends TWSArticleTableAdapter<YardLog> {
  const _TableAdapter();

  String _getDriversName(Driver? driver, DriverExternal? driverExternal) {
    String? name;
    String? fatherlastname;
    String? motherlastname;
    if (driver != null) {
      name = driver.employeeNavigation?.identificationNavigation?.name;
      fatherlastname = driver.employeeNavigation?.identificationNavigation?.fatherlastname;
      motherlastname = driver.employeeNavigation?.identificationNavigation?.motherlastname;
    } else if (driverExternal != null) {
      name = driverExternal.identificationNavigation?.name;
      fatherlastname = driverExternal.identificationNavigation?.fatherlastname;
      motherlastname = driverExternal.identificationNavigation?.motherlastname;
    }
    return "$name $fatherlastname $motherlastname";
  }

  @override
  Future<SetViewOut<YardLog>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<YardLog> options = SetViewOptions<YardLog>(false, range, page, null, orderings, <SetViewFilterNodeInterface<YardLog>>[]);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<YardLog>> resolver = await source.yardLogs.view(options, auth);

    SetViewOut<YardLog> view = await resolver.act((Map<String, dynamic> json) => SetViewOut<YardLog>.des(json, YardLog.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('yard-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }
  
  @override
  TWSArticleTableEditor? composeEditor(YardLog set, void Function() closeReinvoke, BuildContext context) {
    Uint8List? truckPicture = _getBytes(set.ttPicture);
    Uint8List? damagePicture = set.dmgEvidence != null? _getBytes(set.dmgEvidence!) : null;
    bool exceptionFlag = false;
    String xMessage = '---';

    return TWSArticleTableEditor(
      onCancel: closeReinvoke,
      onSave:() async {
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
                  title: 'Yardlog update confirmation',
                  statement: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                        text: 'Are you sure you want to update this Yardlog?',
                      children: <InlineSpan>[
                      const TextSpan(
                          text: '\n',
                        ),
                        const TextSpan(
                          text: '\n\u2022 Log type:',
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
                            child: Text('\n${set.entry? "Entry" : "Departure"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Damage type:',
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
                            child: Text('\n${set.damage? "Damaged" : "Not damaged"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Load type:',
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
                            child: Text('\n${set.loadType == 1? "Loaded": set.loadType == 2? "Not loaded" : "Botado"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Timestamp:',
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
                            child: Text('\n${DateTime.tryParse(set.timestamp.toString()) ?? 'Invalid date'}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Truck:',
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
                            child: Text('\n${set.truckNavigation?.truckCommonNavigation?.economic ?? set.truckExternalNavigation?.truckCommonNavigation?.economic ?? '---'}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Trailer:',
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
                            child: Text('\n${set.trailerNavigation?.trailerCommonNavigation?.economic ?? set.trailerNavigation?.trailerCommonNavigation?.economic ?? '---'}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Driver:',
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
                            child: Text('\n${_getDriverName(set)}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Section:',
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
                            child: Text('\n${set.sectionNavigation?.name ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Sello 1:',
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
                            child: Text('\n${set.seal ?? '---'}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Sello 2:',
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
                            child: Text('\n${set.sealAlt ?? '---'}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onAccept: () async {
                    List<CSMSetValidationResult> evaluation = set.evaluate();
                    if (evaluation.isEmpty) {
                      final String auth = _sessionStorage.getTokenStrict();
                      MainResolver<RecordUpdateOut<YardLog>> resolverUpdateOut =
                          await Sources.foundationSource.yardLogs.update(set, auth);
                      try {
                        resolverUpdateOut
                            .act((JObject json) =>
                                RecordUpdateOut<YardLog>.des(json, YardLog.des))
                            .then(
                          (RecordUpdateOut<YardLog> updateOut) {
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
          child: CSMSpacingColumn(
            spacing: 10,
            children: <Widget>[
              TWSSection(
                title: 'Log type',
                padding: const EdgeInsets.symmetric(vertical: 10),
                content: CSMDynamicWidget<_EntryState>(
                  state: _entryState,
                  designer: (BuildContext ctx, _EntryState state) {
                    return CSMSpacingRow(
                      spacing: 10,
                      children: <Widget>[
                        Expanded(
                          child: TWSButtonFlat(
                            label: 'Entry',
                            disabled: set.entry,
                            onTap: (){
                              set.entry = true;
                              _sectionEffect();
                              state.effect();
                            } 
                          ),
                        ),
                        Expanded(
                          child: TWSButtonFlat(
                            label: 'Departure',
                            disabled: !set.entry,
                            onTap: (){
                              set.entry = false;
                              set.sectionNavigation = null;
                              set.section = null;
                              _sectionEffect();
                              state.effect();
                            } 
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),
              TWSSection(
                title: 'Damage type',
                padding: const EdgeInsets.symmetric(vertical: 10),
                content: CSMDynamicWidget<_DamageState>(
                  state: _damageState,
                  designer: (BuildContext ctx, _DamageState state) {
                    return CSMSpacingRow(
                      spacing: 10,
                      children: <Widget>[
                        Expanded(
                          child: TWSButtonFlat(
                            label: 'No damaged',
                            disabled: !set.damage,
                            onTap: (){
                              set.damage = false;
                              set.dmgEvidence = null;
                              state.effect();
                            } 
                          ),
                        ),
                        Expanded(
                          child: TWSButtonFlat(
                            label: 'Damaged',
                            disabled: set.damage,
                            onTap: (){
                              set.damage = true;
                              state.effect();
                            } 
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),
              TWSSection(
                title: 'Load type',
                padding: const EdgeInsets.symmetric(vertical: 10),
                content: CSMDynamicWidget<_LoadTypeState>(
                  state: _loadTypeState,
                  designer: (BuildContext ctx, _LoadTypeState state) {
                    return CSMSpacingRow(
                      spacing: 10,
                      children: <Widget>[
                        Expanded(
                          child: TWSButtonFlat(
                            label: 'Loaded',
                            disabled: set.loadType == 1,
                            onTap: (){
                              set.loadType = 1;
                              set.loadTypeNavigation = null;
                              state.effect();
                            } 
                          ),
                        ),
                        Expanded(
                          child: TWSButtonFlat(
                            label: 'Empty',
                            disabled: set.loadType == 2,
                            onTap: (){
                              set.loadType = 2;
                              set.loadTypeNavigation = null;
                              state.effect();
                            } 
                          ),
                        ),
                        Expanded(
                          child: TWSButtonFlat(
                            label: 'Botado',
                            disabled: set.loadType == 3,
                            onTap: (){
                              set.loadTypeNavigation = null;
                              set = set.clone(
                                loadType: 3,
                                trailer: 0,
                                trailerExternal: 0,
                                seal: "",
                                sealAlt: ""
                              );
                              state.effect();
                              _sealsEffect();
                              _trailerEffect();
                            } 
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),
              TWSDatepicker(
                width: double.maxFinite,
                addTimePicker: true,
                firstDate: DateTime(1940),
                lastDate: DateTime(2040),
                label: "Fecha",
                controller: TextEditingController(
                  text: DateTime.tryParse(set.timestamp.toString()).toString(),
                ),
                onChanged: (String text) {
                  set = set.clone(
                    timestamp: DateTime.tryParse(text),
                  );
                },
              ),
              TWSAutoCompleteField<Object>(
                width: double.maxFinite,
                label: "Trucks",
                hint: "Select a Truck",
                isOptional: true,
                adapter: const _TruckViewAdapter(),
                initialValue: set.truckNavigation ?? set.trailerExternalNavigation,
                displayValue: (Object? set) {
                  if(set is Truck) return set.truckCommonNavigation?.economic ?? 'Unexpected value';
                  if(set is TruckExternal) return set.truckCommonNavigation?.economic ?? 'Unexpected value';
                  return 'Unexpected value';
                },
                onChanged: (Object? selectedItem) {
                  set = set.clone(
                    truckExternal: selectedItem is TruckExternal? selectedItem.id : 0,
                    truck: selectedItem is Truck? selectedItem.id : 0,
                    truckExternalNavigation: selectedItem is TruckExternal? selectedItem : null,
                    truckNavigation: selectedItem is Truck? selectedItem : null,
                  );
                },
              ),
              CSMDynamicWidget<_TrailerState>(
                state: _trailerState, 
                designer:(BuildContext ctx, _TrailerState state) {
                  _trailerEffect = state.effect;
                  return TWSAutoCompleteField<Object>(
                    width: double.maxFinite,
                    label: "Trailer",
                    hint: "Select a Trailer",
                    isOptional: true,
                    adapter: const _TrailerViewAdapter(),
                    initialValue: set.trailerExternalNavigation ?? set.trailerNavigation,
                    displayValue: (Object? set) {
                      if(set is Trailer) return set.trailerCommonNavigation?.economic ?? 'Unexpected value';
                      if(set is TrailerExternal) return set.trailerCommonNavigation?.economic ?? 'Unexpected value';
                      return 'Unexpected value';
                    },
                    onChanged: (Object? selectedItem) {
                      set = set.clone(
                        trailerExternal: selectedItem is TrailerExternal? selectedItem.id : 0,
                        trailer: selectedItem is Trailer? selectedItem.id : 0,
                        trailerExternalNavigation: selectedItem is TrailerExternal? selectedItem : null,
                        trailerNavigation: selectedItem is Trailer? selectedItem : null,
                      );
                    },
                  );
                },
              ),
              TWSAutoCompleteField<Object>(
                width: double.maxFinite,
                label: "Driver",
                hint: "Select a driver",
                isOptional: true,
                adapter: const _DriverViewAdapter(),
                initialValue: set.driverNavigation ?? set.driverExternalNavigation,
                displayValue: (Object? set) {
                  if(set is DriverExternal) return _getDriversName(null, set);
                  if(set is Driver) return _getDriversName(set, null);
                  return 'Unexpected value';
                },
                onChanged: (Object? selectedItem) {
                  set = set.clone(
                    driver: selectedItem is Driver? selectedItem.id : 0,
                    driverNavigation: selectedItem is Driver? selectedItem : null,
                    driverExternal: selectedItem is DriverExternal? selectedItem.id : 0,
                    driverExternalNavigation: selectedItem is DriverExternal? selectedItem : null,
                  );
                },
              ),
              CSMDynamicWidget<_SectionState>(
                state: _sectionState, 
                designer:(BuildContext ctx, _SectionState state) {
                  _sectionEffect = state.effect;
                  return Visibility(
                    visible: set.entry,
                    child: TWSAutoCompleteField<Section>(
                      width: double.maxFinite,
                      label: "Section",
                      hint: "Select a section",
                      isOptional: true,
                      adapter: const _SectionViewAdapter(),
                      initialValue: set.sectionNavigation,
                      displayValue: (Section? set) {
                        return set != null && set.locationNavigation != null
                            ? "${set.locationNavigation?.name} - ${set.name}: ${(set.ocupancy / set.capacity) * 100}% Ocupado"
                            : 'Unexpected value';
                      },
                      onChanged: (Section? selectedItem) {
                        set = set.clone(
                          section:  selectedItem?.id ?? 0,
                          sectionNavigation:  selectedItem,
                        );
                      },
                    ),
                  );
                },
              ),
              TWSInputText(
                label: "Desde/Hacia",
                hint: "Ingrese la llegada o destino.",
                maxLength: 100,
                isStrictLength: false,
                controller: TextEditingController(
                  text: set.fromTo,
                ),
                onChanged: (String text) {
                  set = set.clone(
                    fromTo: text,
                  );
                },
              ),
              CSMDynamicWidget<_SealsState>(
                state: _sealsState, 
                designer:(BuildContext ctx, _SealsState state) {
                  _sealsEffect = state.effect;
                  return CSMSpacingColumn(
                    spacing: 10,
                    children: <Widget>[
                      TWSInputText(
                        label: "Sello 1",
                        hint: "Ingrese el sello 1",
                        suffixLabel:  ' opt.',
                        maxLength: 64,
                        controller: TextEditingController(
                          text: set.seal,
                        ),
                        onChanged: (String text) {
                          set = set.clone(
                            seal: text,
                          );
                        },
                      ),
                      TWSInputText(
                        label: "Sello 2",
                        hint: "Ingrese el sello 2",
                        suffixLabel:  ' opt.',
                        maxLength: 64,
                        controller: TextEditingController(
                          text: set.sealAlt,
                        ),
                        onChanged: (String text) {
                          set = set.clone(
                            sealAlt: text,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              TWSSection(
                title: 'Truck picture', 
                content: CSMSpacingColumn(
                  spacing: 10,
                  children: <Widget>[
                    if(truckPicture != null)
                    Center(
                      child: TWSImageViewer(
                        align: TextAlign.left,
                        height: 100,
                        width: 300,
                        img: truckPicture,
                      ),
                    ),
                  ] 
                ),
              ),
              if(damagePicture != null)
              TWSSection(
                title: 'Damage picture', 
                content: CSMSpacingColumn(
                  spacing: 10,
                  children: <Widget>[
                    if(truckPicture != null)
                    Center(
                      child: TWSImageViewer(
                        align: TextAlign.left,
                        height: 100,
                        width: 300,
                        img: damagePicture,
                      ),
                    ),
                  ] 
                ),
              ),
            ],
          ),
        ),
      ), 
    );
  }
  
  Uint8List? _getBytes(String base64){
    try{
     return base64Decode(base64);
    }catch(ex){
      return null;
    }
  }

  String getTruckPlates(YardLog item){
    if(item.truckNavigation != null){
      if(item.truckNavigation!.plates.isNotEmpty) return item.truckNavigation!.plates.first.identifier;
    }else if(item.truckExternalNavigation != null){
      if(item.truckExternalNavigation!.mxPlate != null) return item.truckExternalNavigation!.mxPlate!;
      if(item.truckExternalNavigation!.usaPlate != null) return item.truckExternalNavigation!.usaPlate!;
    }
    return 'Placa no encontrada';
  }

  String getTrailerPlates(YardLog item){
    if(item.trailerNavigation != null){
      if(item.trailerNavigation!.plates.isNotEmpty) return item.trailerNavigation!.plates.first.identifier;
    }else if(item.trailerExternalNavigation != null){
      if(item.trailerExternalNavigation!.mxPlate != null) return item.trailerExternalNavigation!.mxPlate!;
      if(item.trailerExternalNavigation!.usaPlate != null) return item.trailerExternalNavigation!.usaPlate!;
    }
    return 'Placa no encontrada';
  }
 @override
  Widget composeViewer(YardLog set, BuildContext context) {
    Uint8List? truckPicture;
    Uint8List? dmgPicture;
    
    truckPicture = _getBytes(set.ttPicture);
    if(set.dmgEvidence != null){
      dmgPicture = _getBytes(set.dmgEvidence!);
    }
  
    return SizedBox.expand(
      child: SingleChildScrollView(
        child: CSMSpacingColumn(
          spacing: 12,
          crossAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TWSPropertyViewer(
              label: 'Tipo de registro',
              value: set.entry? 'Entrada' : 'Salida',
            ),
            TWSPropertyViewer(
              label: 'Tipo de carga',
              value: set.loadTypeNavigation!.name,
            ),
            TWSPropertyViewer(
              label: 'Nombre del conductor',
              value: _getDriverName(set)
            ),
            TWSPropertyViewer(
              label: 'Licencia del conductor',
              value: set.driverNavigation != null? set.driverNavigation?.driverCommonNavigation?.license
              : set.driverExternalNavigation != null? set.driverExternalNavigation?.driverCommonNavigation?.license : "License not found.",
            ),
            TWSPropertyViewer(
              label: 'No. Camión',
              value: set.truckNavigation != null? set.truckNavigation?.truckCommonNavigation?.economic
                : set.truckExternalNavigation != null? set.truckExternalNavigation?.truckCommonNavigation?.economic
                : 'Number not found.',
            ),
            TWSPropertyViewer(
              label: 'Placa de Camión',
              value: getTruckPlates(set),
            ),
            TWSPropertyViewer(
              label: 'No. Remolque',
              value: set.trailerNavigation != null? set.trailerNavigation?.trailerCommonNavigation?.economic
                : set.trailerExternalNavigation != null? set.trailerExternalNavigation?.trailerCommonNavigation?.economic
                : 'Numero economico no encontrado.',
            ),
            TWSPropertyViewer(
              label: 'Placa de remolque',
              value: getTrailerPlates(set)
            ),
            TWSPropertyViewer(
              label: 'Numero de sello',
              value: set.seal,
            ),
            TWSPropertyViewer(
              label: 'Desde/Hacia',
              value: set.fromTo,
            ),
            TWSPropertyViewer(
              label: 'Daño',
              value: set.damage? "Dañado" : "Ninguno",
            ),
            TWSPropertyViewer(
              label: 'Section',
              value: set.sectionNavigation != null? "${set.sectionNavigation?.locationNavigation?.name} - ${set.sectionNavigation?.name}" : null,
            ),
        
            //Images sections
        
            //Truck Picture
            if(truckPicture == null)
            const TWSPropertyViewer(
              label: 'Foto del Camión/Remolque',
              value: "Error al cargar la imagen.",
            ),
        
            if(truckPicture != null)
            TWSImageViewer(
              align: TextAlign.left,
              height: 100,
              width: 300,
              title: "Foto del camión/remolque:",
              img: truckPicture
            ),
        
            //dmg Picture
            if(set.dmgEvidence == null)
            const TWSPropertyViewer(
              label: 'Foto del daño',
              value: "N/A",
            ),
        
            if(dmgPicture == null && set.dmgEvidence != null)
            const TWSPropertyViewer(
              label: 'Foto del daño',
              value: "Error al cargar la imagen.",
            ),
        
            if(dmgPicture != null)
            TWSImageViewer(
              align: TextAlign.left,
              height: 100,
              width: 300,
              title: "Foto del daño:",
              img: dmgPicture
            )
          ],
        ),
      ),
    );
  }
}

final class _DriverViewAdapter implements TWSAutocompleteAdapter {
  const _DriverViewAdapter();
  @override
  Future<List<SetViewOut<dynamic>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    List<SetViewOut<dynamic>> rawViews = <SetViewOut<dynamic>>[];
    String auth = _sessionStorage.session!.token;

    // Search filters;
    List<SetViewFilterNodeInterface<Driver>> nodeFilters = <SetViewFilterNodeInterface<Driver>>[];
    List<SetViewFilterNodeInterface<DriverExternal>> nodeFiltersExternal = <SetViewFilterNodeInterface<DriverExternal>>[];

     List<SetViewFilterInterface<Driver>> filters = <SetViewFilterInterface<Driver>>[];
    List<SetViewFilterInterface<DriverExternal>> filtersExternal = <SetViewFilterInterface<DriverExternal>>[];

    
    // -> Drivers names filters.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<Driver> nameFilter = SetViewPropertyFilter<Driver>(0, SetViewFilterEvaluations.contians, 'EmployeeNavigation.IdentificationNavigation.Name', input);
      SetViewPropertyFilter<Driver> fatherFilter = SetViewPropertyFilter<Driver>(0, SetViewFilterEvaluations.contians, 'EmployeeNavigation.IdentificationNavigation.FatherLastname', input);
      SetViewPropertyFilter<Driver> motherFilter = SetViewPropertyFilter<Driver>(0, SetViewFilterEvaluations.contians, 'EmployeeNavigation.IdentificationNavigation.MotherLastname', input);
      
      SetViewPropertyFilter<DriverExternal> nameFilterExternal = SetViewPropertyFilter<DriverExternal>(0, SetViewFilterEvaluations.contians, 'IdentificationNavigation.Name', input);
      SetViewPropertyFilter<DriverExternal> fatherFilterExternal = SetViewPropertyFilter<DriverExternal>(0, SetViewFilterEvaluations.contians, 'IdentificationNavigation.FatherLastname', input);
      SetViewPropertyFilter<DriverExternal> motherFilterExternal = SetViewPropertyFilter<DriverExternal>(0, SetViewFilterEvaluations.contians, 'IdentificationNavigation.MotherLastname', input);

      // -> adding filters
      filters =  <SetViewFilterInterface<Driver>>[
        nameFilter, 
        fatherFilter, 
        motherFilter,
      ];

      filtersExternal = <SetViewFilterInterface<DriverExternal>>[
        nameFilterExternal, 
        fatherFilterExternal, 
        motherFilterExternal,
      ];

      SetViewFilterLinearEvaluation<Driver> searchFilterOption = SetViewFilterLinearEvaluation<Driver>(3, SetViewFilterEvaluationOperators.or, filters);
      SetViewFilterLinearEvaluation<DriverExternal> searchExternalFilterOption = SetViewFilterLinearEvaluation<DriverExternal>(3, SetViewFilterEvaluationOperators.or, filtersExternal);
      nodeFilters.add(searchFilterOption);
      nodeFiltersExternal.add(searchExternalFilterOption);
    }
    

    final SetViewOptions<Driver> optionsDrivers = SetViewOptions<Driver>(false, range, page, null, orderings, nodeFilters);
    final MainResolver<SetViewOut<Driver>> resolver = await source.drivers.view(optionsDrivers, auth);
    final SetViewOut<Driver> view = await resolver.act((Map<String, dynamic> json) => SetViewOut<Driver>.des(json, Driver.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('driver-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
        throw x;
      },
    );
    rawViews.add(view);


    final SetViewOptions<DriverExternal> optionsDriversExternals = SetViewOptions<DriverExternal>(false, range, page, null, orderings, nodeFiltersExternal);
    final MainResolver<SetViewOut<DriverExternal>> externalResolver = await source.driversExternals.view(optionsDriversExternals, auth);
    final SetViewOut<DriverExternal> externalView = await externalResolver.act((Map<String, dynamic> json) => SetViewOut<DriverExternal>.des(json, DriverExternal.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('external-driver-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
        throw x;
      },
    );
    rawViews.add(externalView);

    return rawViews;
  }
}

final class _TrailerViewAdapter implements TWSAutocompleteAdapter{
  const _TrailerViewAdapter();

  @override
  Future<List<SetViewOut<dynamic>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    List<SetViewOut<dynamic>> rawViews = <SetViewOut<dynamic>>[];
    String auth = _sessionStorage.session!.token;

    // Search filters;
    List<SetViewFilterNodeInterface<Trailer>> filters = <SetViewFilterNodeInterface<Trailer>>[];
    List<SetViewFilterNodeInterface<TrailerExternal>> filtersExternal = <SetViewFilterNodeInterface<TrailerExternal>>[];

    // -> Trailers economic filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<Trailer> econoFilter = SetViewPropertyFilter<Trailer>(0, SetViewFilterEvaluations.contians, 'TrailerCommonNavigation.Economic', input);
      SetViewPropertyFilter<TrailerExternal> econoFilterExternal = SetViewPropertyFilter<TrailerExternal>(0, SetViewFilterEvaluations.contians, 'TrailerCommonNavigation.Economic', input);
      // -> adding filters
      filters.add(econoFilter);
      filtersExternal.add(econoFilterExternal);
    }
    
    final SetViewOptions<Trailer> options = SetViewOptions<Trailer>(false, range, page, null, orderings, filters);
    final MainResolver<SetViewOut<Trailer>> resolver = await source.trailers.view(options, auth);
    final SetViewOut<Trailer> view = await resolver.act((Map<String, dynamic> json) => SetViewOut<Trailer>.des(json, Trailer.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('trailerExternal-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
        throw x;
      },
    );
    rawViews.add(view);

    final SetViewOptions<TrailerExternal> optionsExternals = SetViewOptions<TrailerExternal>(false, range, page, null, orderings, filtersExternal);
    final MainResolver<SetViewOut<TrailerExternal>> externalResolver = await source.trailersExternals.view(optionsExternals, auth);
    final SetViewOut<TrailerExternal> externalView = await externalResolver.act((Map<String, dynamic> json) => SetViewOut<TrailerExternal>.des(json, TrailerExternal.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('trailerExternal-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
        throw x;
      },
    );
    rawViews.add(externalView);
    return rawViews;
  }
}
final class _TruckViewAdapter implements TWSAutocompleteAdapter{
  const _TruckViewAdapter();

  @override
  Future<List<SetViewOut<dynamic>>> consume(int page, int range, List<SetViewOrderOptions> orderings, String input) async {
    List<SetViewOut<dynamic>> rawViews = <SetViewOut<dynamic>>[];
    String auth = _sessionStorage.session!.token;

    // Search filters;
    List<SetViewFilterNodeInterface<Truck>> filters = <SetViewFilterNodeInterface<Truck>>[];
    List<SetViewFilterNodeInterface<TruckExternal>> filtersExternal = <SetViewFilterNodeInterface<TruckExternal>>[];

    // -> Trucks economic filter.
    if (input.trim().isNotEmpty) {
      // -> filters
      SetViewPropertyFilter<Truck> econoFilter = SetViewPropertyFilter<Truck>(0, SetViewFilterEvaluations.contians, 'TruckCommonNavigation.Economic', input);
      SetViewPropertyFilter<TruckExternal> econoFilterExternal = SetViewPropertyFilter<TruckExternal>(0, SetViewFilterEvaluations.contians, 'TruckCommonNavigation.Economic', input);
      // -> adding filters
      filters.add(econoFilter);
      filtersExternal.add(econoFilterExternal);
    }

    final SetViewOptions<Truck> options = SetViewOptions<Truck>(false, range, page, null, orderings, filters);
    final MainResolver<SetViewOut<Truck>> resolver = await source.trucks.view(options, auth);
    final SetViewOut<Truck> view = await resolver.act((Map<String, dynamic> json) => SetViewOut<Truck>.des(json, Truck.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('trailerExternal-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
        throw x;
      },
    );
    rawViews.add(view);

    final SetViewOptions<TruckExternal> optionsExternals = SetViewOptions<TruckExternal>(false, range, page, null, orderings, filtersExternal);
    final MainResolver<SetViewOut<TruckExternal>> externalResolver = await source.trucksExternals.view(optionsExternals, auth);
    final SetViewOut<TruckExternal> externalView = await externalResolver.act((Map<String, dynamic> json) => SetViewOut<TruckExternal>.des(json, TruckExternal.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('trailerExternal-future-autocomplete-field-adapter').exception('Exception catched at Future Autocomplete field consume', Exception(x), s);
        throw x;
      },
    );
    rawViews.add(externalView);
    return rawViews;
  }
}

final class _SectionViewAdapter implements TWSAutocompleteAdapter{
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
    final MainResolver<SetViewOut<Section>> resolver = await source.sections.view(options, auth);
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

