part of '../../trucks_article.dart';


/// [_ExternalTableAdapter] class stores consumes the data and all the compose components for the table [TruckExternal] table.
final class _ExternalTableAdapter extends TWSArticleTableAdapter<TruckExternal> {
  final _TrucksArticleState state;
  const _ExternalTableAdapter(this.state);
  @override
  Future<SetViewOut<TruckExternal>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<TruckExternal> options = SetViewOptions<TruckExternal>(false, range, page, null, orderings, state.externalsFilters);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<TruckExternal>> resolver = await Sources.foundationSource.trucksExternals.view(options, auth);

    SetViewOut<TruckExternal> view = await resolver.act((JObject json) => SetViewOut<TruckExternal>.des(json, TruckExternal.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('truck-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }
  
  @override
  TWSArticleTableEditor? composeEditor(TruckExternal set, Function closeReinvoke, BuildContext context) {
    bool exceptionFlag = false;
    String xMessage = '---';

    return TWSArticleTableEditor(
      onCancel: closeReinvoke,
      onSave: () async {
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
                      text: 'Are you sure you want to update an external truck?',
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
                            child: Text('\n${set.carrier}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 VIN:',
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
                            child: Text('\n${set.vin ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 Mexican plate:',
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
                            child: Text('\n${set.mxPlate ?? "---"}'),
                          ),
                        ),
                        const TextSpan(
                          text: '\n\u2022 American plate:',
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
                            child: Text('\n${set.usaPlate ?? "---"}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onAccept: () async {
                    List<CSMSetValidationResult> evaluation = set.evaluate();
                    if(evaluation.isEmpty){
                      final String auth = _sessionStorage.getTokenStrict();
                      MainResolver<RecordUpdateOut<TruckExternal>> resolverUpdateOut = await Sources.foundationSource.trucksExternals.update(set, auth);
                      try {
                        resolverUpdateOut.act((JObject json) => RecordUpdateOut<TruckExternal>.des(json, TruckExternal.des)).then(
                          (RecordUpdateOut<TruckExternal> updateOut) {
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
                    }else{
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
                                      text: "${i + 1} - ${evaluation[i].property}: ${evaluation[i].reason}\n",
                                      style: const TextStyle(fontWeight: FontWeight.w600),
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
              TWSInputText(
                label: "Economic",
                hint: "enter an economic number",
                maxLength: 16,
                isStrictLength: true,
                controller: TextEditingController(text: set.truckCommonNavigation!.economic),
                onChanged: (String text) {
                  set = set.clone(
                    truckCommonNavigation: set.truckCommonNavigation?.clone(
                      economic: text,
                    ),
                  );
                },
              ),
              TWSInputText(
                label: "Carrier",
                hint: "enter a carrier number",
                maxLength: 100,
                isStrictLength: true,
                controller: TextEditingController(text: set.carrier),
                onChanged: (String text) {
                  set = set.clone(
                    carrier: text,
                  );
                },
              ),
              TWSInputText(
                label: "MX Plate",
                hint: "enter a Mexican plate",
                maxLength: 12,
                isStrictLength: true,
                controller: TextEditingController(text: set.mxPlate),
                onChanged: (String text) {
                  set = set.clone(
                    mxPlate: text,
                  );
                },
              ),
              TWSInputText(
                label: "USA Plate",
                hint: "enter a USA plate",
                maxLength: 12,
                isStrictLength: true,
                controller: TextEditingController(text: set.usaPlate),
                onChanged: (String text) {
                  set = set.clone(
                    usaPlate: text,
                  );
                },
              ),
              TWSInputText(
                label: "VIN",
                hint: "enter a vin number",
                maxLength: 17,
                isOptional: true,
                suffixLabel: " (optional)",
                isStrictLength: true,
                controller: TextEditingController(text: set.vin),
                onChanged: (String text) {
                  set = set.clone(
                    vin: text,
                  );
                },
              ),
            ]
          ),
        ),
      ), 
    );
  }

  @override
  Widget composeViewer(TruckExternal set, BuildContext context) {
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
            label: 'Carrier',
            value: set.carrier,
          ),
          TWSPropertyViewer(
            label: 'MX Plates',
            value: set.mxPlate 
          ),
          TWSPropertyViewer(
            label: 'USA Plates',
            value: set.usaPlate 
          ),
          TWSPropertyViewer(
            label: 'VIN',
            value: set.vin,
          ),
        ],
      ),
    );
  }
}
