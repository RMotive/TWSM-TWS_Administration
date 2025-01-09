part of '../../drivers_article.dart';

/// [_TableAdapter] class stores cons umes the data and all the compose components for the table [DriverExternal] table.
final class _ExternalTableAdapter extends TWSArticleTableAdapter<DriverExternal> {
  const _ExternalTableAdapter();

  @override
  Future<SetViewOut<DriverExternal>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<DriverExternal> options = SetViewOptions<DriverExternal>(false, range, page, null, orderings, <SetViewFilterNodeInterface<DriverExternal>>[]);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<DriverExternal>> resolver = await Sources.foundationSource.driversExternals.view(options, auth);

    SetViewOut<DriverExternal> view = await resolver.act((JObject json) => SetViewOut<DriverExternal>.des(json, DriverExternal.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('external-drivers-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }

  @override
  TWSArticleTableEditor? composeEditor(DriverExternal set, void Function() closeReinvoke, BuildContext context) {

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
              title: 'External Driver update confirmation',
              statement: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                    text: 'Are you sure you want to update an external driver?',
                  children: <InlineSpan>[
                   const TextSpan(
                      text: '\n',
                    ),
                    const TextSpan(
                      text: '\n\u2022 License:',
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
                        child: Text('\n${set.driverCommonNavigation?.license ?? "---"}'),
                      ),
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
                        child: Text('\n${set.identificationNavigation?.name ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Father lastname:',
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
                        child: Text('\n${set.identificationNavigation?.fatherlastname ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Mother lastname:',
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
                        child: Text('\n${set.identificationNavigation?.motherlastname ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Birthday:',
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
                        child: Text('\n${set.identificationNavigation?.birthday?.dateOnlyString ?? "---"}'),
                      ),
                    ),
                  ],
                ),
              ),
              onAccept: () async {
                List<CSMSetValidationResult> evaluation = set.evaluate();
                if (evaluation.isEmpty) {
                  final String auth = _sessionStorage.getTokenStrict();
                  MainResolver<RecordUpdateOut<DriverExternal>> resolverUpdateOut =
                      await Sources.foundationSource.driversExternals.update(set, auth);
                  try {
                    resolverUpdateOut
                        .act((JObject json) =>
                            RecordUpdateOut<DriverExternal>.des(json, DriverExternal.des))
                        .then(
                      (RecordUpdateOut<DriverExternal> updateOut) {
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
          child: CSMSpacingColumn(
            spacing: 10,
            children: <Widget>[
              TWSInputText(
                label: "License",
                hint: "Enter a License number",
                maxLength: 16,
                isStrictLength: true,
                controller: TextEditingController(
                  text: set.driverCommonNavigation?.license,
                ),
                onChanged: (String text) {
                  set = set.clone(
                    driverCommonNavigation:
                        set.driverCommonNavigation!.clone(license: text),
                  );
                },
              ),
              TWSInputText(
                label: "Name",
                hint: "Enter a name",
                maxLength: 16,
                isStrictLength: true,
                controller: TextEditingController(
                  text: set.identificationNavigation?.name,
                ),
                onChanged: (String text) {
                  set = set.clone(
                    identificationNavigation:
                        set.identificationNavigation!.clone(name: text),
                  );
                },
              ),
              TWSInputText(
                label: "Father lastname",
                hint: "enter a father lastname",
                maxLength: 16,
                isStrictLength: true,
                controller: TextEditingController(
                  text: set.identificationNavigation?.fatherlastname,
                ),
                onChanged: (String text) {
                   set = set.clone(
                    identificationNavigation:
                        set.identificationNavigation!.clone(fatherlastname: text),
                  );
                },
              ),
              TWSInputText(
                label: "Mother lastname",
                hint: "enter a mother lastname",
                maxLength: 16,
                isStrictLength: true,
                controller: TextEditingController(
                  text: set.identificationNavigation?.motherlastname,
                ),
                onChanged: (String text) {
                   set = set.clone(
                    identificationNavigation:
                        set.identificationNavigation!.clone(motherlastname: text),
                  );
                },
              ),
              TWSDatepicker(
                width: double.maxFinite,
                firstDate: DateTime(1940),
                lastDate: DateTime(2040),
                label: "Expiration",
                controller: TextEditingController(
                  text: set.identificationNavigation?.birthday?.dateOnlyString,
                ),
                onChanged: (String text) {
                  set.identificationNavigation = set.identificationNavigation
                      ?.clone(birthday: DateTime.tryParse(text) ?? DateTime(0));
                },
              ),
            ],
          ),
        ),
      ), 
    );
  }

  @override
  Widget? composeViewer(DriverExternal set, BuildContext context) {
    return SizedBox.expand(
      child: CSMSpacingColumn(
        spacing: 10,
        children: <TWSPropertyViewer>[
          TWSPropertyViewer(
            label: "License number", 
            value: set.driverCommonNavigation?.license ?? "---",
          ),
          TWSPropertyViewer(
            label: "Name", 
            value: set.identificationNavigation?.name ?? "---",
          ),
          TWSPropertyViewer(
            label: "Father lastname", 
            value: set.identificationNavigation?.fatherlastname ?? "---",
          ),
          TWSPropertyViewer(
            label: "Mother lastname", 
            value: set.identificationNavigation?.motherlastname ?? "---",
          ),
          TWSPropertyViewer(
            label: "Birthday", 
            value: set.identificationNavigation?.birthday?.dateOnlyString ?? "---",
          ),
          
        ]
      ),
    );
  }

 

  
}