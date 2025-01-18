part of '../../trailers_article.dart';


/// [_ExternalTableAdapter] class stores consumes the data and all the compose components for the table [TrailerExternal] table.
final class _ExternalTableAdapter extends TWSArticleTableAdapter<TrailerExternal> {
  final _TrailersArticleState state;
  const _ExternalTableAdapter(this.state);

  @override
  Future<SetViewOut<TrailerExternal>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<TrailerExternal> options = SetViewOptions<TrailerExternal>(false, range, page, null, orderings, state.externalsFilters);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<TrailerExternal>> resolver = await Sources.foundationSource.trailersExternals.view(options, auth);

    SetViewOut<TrailerExternal> view = await resolver.act((JObject json) => SetViewOut<TrailerExternal>.des(json, TrailerExternal.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('trailer-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }
  
  @override
  TWSArticleTableEditor? composeEditor(TrailerExternal set, Function closeReinvoke, BuildContext context) {
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
                  title: 'Trailer update confirmation',
                  statement: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'Are you sure you want to update an external trailer?',
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
                            child: Text('\n${set.carrier}'),
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
                            child: Text( set.trailerCommonNavigation?.trailerTypeNavigation != null? '${set.trailerCommonNavigation?.trailerTypeNavigation?.trailerClassNavigation?.name ?? "---"} - ${set.trailerCommonNavigation?.trailerTypeNavigation?.size ?? "---"}' : "---"),
                          ),
                        ),
                      ]
                    ),
                  ),
                  onAccept: () async {
                    List<CSMSetValidationResult> evaluation = set.evaluate();
                    if(evaluation.isEmpty){
                      final String auth = _sessionStorage.getTokenStrict();
                      MainResolver<RecordUpdateOut<TrailerExternal>> resolverUpdateOut = await Sources.foundationSource.trailersExternals.update(set, auth);
                      try {
                        resolverUpdateOut.act((JObject json) => RecordUpdateOut<TrailerExternal>.des(json, TrailerExternal.des)).then(
                          (RecordUpdateOut<TrailerExternal> updateOut) {
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
                controller: TextEditingController(text: set.trailerCommonNavigation!.economic),
                onChanged: (String text) {
                  set = set.clone(
                    trailerCommonNavigation: set.trailerCommonNavigation?.clone(
                      economic: text,
                    ),
                  );
                },
              ),
              TWSInputText(
                label: "Carrier",
                hint: "enter a motor number",
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
                      type: selectedItem?.id ?? 0,
                      trailerTypeNavigation: selectedItem
                    ),
                  );
                },
                displayValue: (TrailerType? set) {
                  return set != null? "${set.trailerClassNavigation?.name} - ${set.size}" : "error";
                },
              ),
            ]
          ),
        ),
      ), 
    );
  }

  @override
  Widget composeViewer(TrailerExternal set, BuildContext context) {
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
            label: 'Carrier',
            value: set.carrier,
          ),
          TWSPropertyViewer(
            label: 'Type',
            value: set.trailerCommonNavigation?.trailerTypeNavigation != null? '${set.trailerCommonNavigation?.trailerTypeNavigation?.trailerClassNavigation?.name ?? "---"} - ${set.trailerCommonNavigation?.trailerTypeNavigation?.size ?? "---"}' : "---"
          ),
          TWSPropertyViewer(
            label: 'MX Plates',
            value: set.mxPlate ?? '---'
          ),
          TWSPropertyViewer(
            label: 'USA Plates',
            value: set.usaPlate ?? '---'
          ),
          TWSPropertyViewer(
            label: 'Situation',
            value: set.trailerCommonNavigation?.situationNavigation?.name ?? '---',
          ),
        ],
      ),
    );
  }
}
