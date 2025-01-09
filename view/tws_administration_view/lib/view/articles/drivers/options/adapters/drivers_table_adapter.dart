part of '../../drivers_article.dart';

final SessionStorage _sessionStorage = SessionStorage.i;
const List<String> _countryOptions = TWSAMessages.kCountryList;
const List<String> _usaStateOptions = TWSAMessages.kUStateCodes;
const List<String> _mxStateOptions = TWSAMessages.kMXStateCodes;
class _AddresState extends CSMStateBase {}
_AddresState _addresState = _AddresState();
void Function() _addressEffect = () {};

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

/// [_TableAdapter] class stores cons umes the data and all the compose components for the table [Drivers] table.
final class _TableAdapter extends TWSArticleTableAdapter<Driver> {
  const _TableAdapter();

  @override
  Future<SetViewOut<Driver>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<Driver> options = SetViewOptions<Driver>(false, range, page, null, orderings, <SetViewFilterNodeInterface<Driver>>[]);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<Driver>> resolver = await Sources.foundationSource.drivers.view(options, auth);

    SetViewOut<Driver> view = await resolver.act((JObject json) => SetViewOut<Driver>.des(json, Driver.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('drivers-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }

  @override
  TWSArticleTableEditor? composeEditor(Driver set, void Function() closeReinvoke, BuildContext context) {

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
              title: 'Driver update confirmation',
              statement: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                    text: 'Are you sure you want to update a driver?',
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
                      text: '\n\u2022 Driver type:',
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
                        child: Text('\n${set.driverType ?? "---"}'),
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
                        child: Text('\n${set.driverCommonNavigation?.situationNavigation?.name ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Licence expiration:',
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
                        child: Text('\n${set.licenseExpiration?.dateOnlyString ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Drugal reg. date:',
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
                        child: Text('\n${set.drugalcRegistrationDate?.dateOnlyString ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Pull notice reg. date:',
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
                        child: Text('\n${set.pullnoticeRegistrationDate?.dateOnlyString ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 TWIC number:',
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
                        child: Text('\n${set.twic ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 TWIC expiration:',
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
                        child: Text('\n${set.twicExpiration?.dateOnlyString ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 VISA number:',
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
                        child: Text('\n${set.visa ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 VISA expiration:',
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
                        child: Text('\n${set.visaExpiration?.dateOnlyString ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 FAST number:',
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
                        child: Text('\n${set.fast ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 FAST expiration:',
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
                        child: Text('\n${set.fastExpiration?.dateOnlyString ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 ANAM number:',
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
                        child: Text('\n${set.anam ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 ANAM expiration:',
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
                        child: Text('\n${set.anamExpiration?.dateOnlyString ?? "---"}'),
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
                        child: Text('\n${set.employeeNavigation?.identificationNavigation?.name ?? "---"}'),
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
                        child: Text('\n${set.employeeNavigation?.identificationNavigation?.fatherlastname ?? "---"}'),
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
                        child: Text('\n${set.employeeNavigation?.identificationNavigation?.motherlastname ?? "---"}'),
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
                        child: Text('\n${set.employeeNavigation?.identificationNavigation?.birthday?.dateOnlyString ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Email:',
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
                        child: Text('\n${set.employeeNavigation?.approachNavigation?.email ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Entreprise phone:',
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
                        child: Text('\n${set.employeeNavigation?.approachNavigation?.enterprise ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Personal phone:',
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
                        child: Text('\n${set.employeeNavigation?.approachNavigation?.personal ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Alternative contact:',
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
                        child: Text('\n${set.employeeNavigation?.approachNavigation?.alternative ?? "---"}'),
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
                        child: Text('\n${set.employeeNavigation?.addressNavigation?.country ?? "---"}'),
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
                        child: Text('\n${set.employeeNavigation?.addressNavigation?.state ?? "---"}'),
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
                        child: Text('\n${set.employeeNavigation?.addressNavigation?.street ?? "---"}'),
                      ),
                    ),
                    const TextSpan(
                      text: '\n\u2022 Alt. Street:',
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
                        child: Text('\n${set.employeeNavigation?.addressNavigation?.altStreet ?? "---"}'),
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
                        child: Text('\n${set.employeeNavigation?.addressNavigation?.city ?? "---"}'),
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
                        child: Text('\n${set.employeeNavigation?.addressNavigation?.zip ?? "---"}'),
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
                        child: Text('\n${set.employeeNavigation?.addressNavigation?.colonia ?? "---"}'),
                      ),
                    ),
                  ],
                ),
              ),
              onAccept: () async {
                List<CSMSetValidationResult> evaluation = set.evaluate();
                if (evaluation.isEmpty) {
                  final String auth = _sessionStorage.getTokenStrict();
                  MainResolver<RecordUpdateOut<Driver>> resolverUpdateOut =
                      await Sources.foundationSource.drivers.update(set, auth);
                  try {
                    resolverUpdateOut
                        .act((JObject json) =>
                            RecordUpdateOut<Driver>.des(json, Driver.des))
                        .then(
                      (RecordUpdateOut<Driver> updateOut) {
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
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: CSMSpacingColumn(
            spacing: 10,
            children: <Widget>[
              TWSInputText(
                label: "License",
                hint: "Enter a License number",
                maxLength: 12,
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
                label: "Driver type",
                hint: "Enter the driver type",
                suffixLabel: ' opt.',
                maxLength: 16,
                controller: TextEditingController(text: set.driverType),
                onChanged: (String text) {
                  set = set.clone(
                    driverType: text,
                  );
                },
              ),
              TWSAutoCompleteField<Situation>(
                width: double.maxFinite,
                label: "Situation",
                hint: "Select a situation",
                isOptional: true,
                adapter: const _SituationsViewAdapter(),
                initialValue: set.driverCommonNavigation?.situationNavigation,
                displayValue: (Situation? set) {
                  return set?.name ?? 'Unexpected value';
                },
                onChanged: (Situation? selectedItem) {
                  set.statusNavigation = null;
                  set = set.clone(
                    driverCommonNavigation: set.driverCommonNavigation?.clone(
                      situation: selectedItem?.id ?? 0,
                      situationNavigation: selectedItem,
                    ),
                  );
                },
              ),
              TWSDatepicker(
                width: double.maxFinite,
                firstDate: DateTime(1999),
                lastDate: DateTime(2040),
                label: "License expiration",
                suffixLabel: ' opt.',
                controller: TextEditingController(
                  text: set.licenseExpiration?.dateOnlyString,
                ),
                onChanged: (String text) {
                  set = set.clone(
                    licenseExpiration: DateTime.tryParse(text) ?? DateTime(0),
                  );
                },
              ),
              TWSDatepicker(
                width: double.maxFinite,
                firstDate: DateTime(1999),
                lastDate: DateTime(2040),
                label: "Drugal reg. date",
                suffixLabel: ' opt.',
                controller: TextEditingController(
                  text: set.drugalcRegistrationDate?.dateOnlyString,
                ),
                onChanged: (String text) {
                  set = set.clone(
                    drugalcRegistrationDate: DateTime.tryParse(text) ?? DateTime(0),
                  );
                },
              ),
              TWSDatepicker(
                width: double.maxFinite,
                firstDate: DateTime(1999),
                lastDate: DateTime(2040),
                label: "Pull notice reg. date",
                suffixLabel: ' opt.',
                controller: TextEditingController(
                  text: set.pullnoticeRegistrationDate?.dateOnlyString,
                ),
                onChanged: (String text) {
                  set = set.clone(
                    pullnoticeRegistrationDate: DateTime.tryParse(text) ?? DateTime(0),
                  );
                },
              ),
              TWSInputText(
                label: "TWIC number",
                hint: "Enter the TWIC number",
                suffixLabel: ' opt.',
                maxLength: 12,
                isStrictLength: true,
                controller: TextEditingController(text: set.twic),
                onChanged: (String text) {
                  set = set.clone(
                    twic: text,
                  );
                },
              ),
              TWSDatepicker(
                width: double.maxFinite,
                firstDate: DateTime(1999),
                lastDate: DateTime(2040),
                label: "TWIC expiration",
                suffixLabel: ' opt.',
                controller: TextEditingController(
                  text: set.twicExpiration?.dateOnlyString,
                ),
                onChanged: (String text) {
                  set = set.clone(
                    twicExpiration: DateTime.tryParse(text) ?? DateTime(0),
                  );
                },
              ),
              TWSInputText(
                label: "VISA number",
                hint: "Enter the VISA number",
                suffixLabel: ' opt.',
                maxLength: 12,
                isStrictLength: true,
                controller: TextEditingController(text: set.visa),
                onChanged: (String text) {
                  set = set.clone(
                    visa: text,
                  );
                },
              ),
              TWSDatepicker(
                width: double.maxFinite,
                firstDate: DateTime(1999),
                lastDate: DateTime(2040),
                label: "VISA expiration",
                suffixLabel: ' opt.',
                controller: TextEditingController(
                  text: set.visaExpiration?.dateOnlyString,
                ),
                onChanged: (String text) {
                  set = set.clone(
                    visaExpiration: DateTime.tryParse(text) ?? DateTime(0),
                  );
                },
              ),
              TWSInputText(
                label: "FAST number",
                hint: "Enter the FAST number",
                suffixLabel: ' opt.',
                maxLength: 14,
                isStrictLength: true,
                controller: TextEditingController(text: set.fast),
                onChanged: (String text) {
                  set = set.clone(
                    fast: text,
                  );
                },
              ),
              TWSDatepicker(
                width: double.maxFinite,
                firstDate: DateTime(1999),
                lastDate: DateTime(2040),
                label: "FAST expiration",
                suffixLabel: ' opt.',
                controller: TextEditingController(
                  text: set.fastExpiration?.dateOnlyString,
                ),
                onChanged: (String text) {
                  set = set.clone(
                    fastExpiration: DateTime.tryParse(text) ?? DateTime(0),
                  );
                },
              ),
              TWSInputText(
                label: "ANAM number",
                hint: "Enter the ANAM number",
                suffixLabel: ' opt.',
                maxLength: 24,
                isStrictLength: true,
                controller: TextEditingController(text: set.anam),
                onChanged: (String text) {
                  set = set.clone(
                    anam: text,
                  );
                },
              ),
              TWSDatepicker(
                width: double.maxFinite,
                firstDate: DateTime(1999),
                lastDate: DateTime(2040),
                label: "ANAM expiration",
                suffixLabel: ' opt.',
                controller: TextEditingController(
                  text: set.anamExpiration?.dateOnlyString,
                ),
                onChanged: (String text) {
                  set = set.clone(
                    anamExpiration: DateTime.tryParse(text) ?? DateTime(0),
                  );
                },
              ),
              TWSSection(
                padding: const EdgeInsets.symmetric(vertical: 10),
                title: 'Identity', 
                content: CSMSpacingColumn(
                  spacing: 10,
                  children: <Widget>[
                    TWSInputText(
                      label: "Name",
                      hint: "Enter a name",
                      maxLength: 32,
                      controller: TextEditingController(
                        text: set.employeeNavigation?.identificationNavigation?.name,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            identificationNavigation: set.employeeNavigation?.identificationNavigation?.clone(
                              name: text,
                            ),
                          ),
                        );
                      },
                    ),
                    TWSInputText(
                      label: "Father lastname",
                      hint: "enter a father lastname",
                      maxLength: 32,
                      controller: TextEditingController(
                        text: set.employeeNavigation?.identificationNavigation?.fatherlastname,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            identificationNavigation: set.employeeNavigation?.identificationNavigation?.clone(
                              fatherlastname: text,
                            ),
                          ),
                        );
                      },
                    ),
                    TWSInputText(
                      label: "Mother lastname",
                      hint: "enter a mother lastname",
                      maxLength: 32,
                      controller: TextEditingController(
                        text: set.employeeNavigation?.identificationNavigation?.motherlastname,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            identificationNavigation: set.employeeNavigation?.identificationNavigation?.clone(
                              motherlastname: text,
                            ),
                          ),
                        );
                      },
                    ),
                    TWSDatepicker(
                      width: double.maxFinite,
                      firstDate: DateTime(1940),
                      lastDate: DateTime(2040),
                      label: "Birthday",
                      suffixLabel: ' opt.',
                      controller: TextEditingController(
                        text: set.employeeNavigation?.identificationNavigation?.birthday?.dateOnlyString,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            identificationNavigation: set.employeeNavigation?.identificationNavigation?.clone(
                              birthday: DateTime.tryParse(text) ?? DateTime(0),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              if(set.employeeNavigation?.addressNavigation != null) 
              TWSSection(
                padding: const EdgeInsets.symmetric(vertical: 10),
                title: 'Conctact', 
                content: CSMSpacingColumn(
                  spacing: 10,
                  children: <Widget>[
                    TWSInputText(
                      label: "Email",
                      hint: "Enter an email",
                      maxLength: 64,
                      controller: TextEditingController(
                        text: set.employeeNavigation?.approachNavigation?.email,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            approachNavigation: set.employeeNavigation?.approachNavigation?.clone(
                              email: text,
                            ) ?? Approach.a().clone(
                              email: text,
                            ),
                          ),
                        );
                      },
                    ),
                    TWSInputText(
                      label: "Entreprise phone",
                      suffixLabel: ' opt.',
                      hint: "enter an entreprise phone",
                      maxLength: 14,
                      controller: TextEditingController(
                        text: set.employeeNavigation?.approachNavigation?.enterprise,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            approachNavigation: set.employeeNavigation?.approachNavigation?.clone(
                              enterprise: text,
                            ) ?? Approach.a().clone(
                              enterprise: text,
                            ),
                          ),
                        );
                      },
                    ),
                    TWSInputText(
                      label: "Personal phone",
                      suffixLabel: ' opt.',
                      hint: "enter a personal phone",
                      maxLength: 16,
                      controller: TextEditingController(
                        text: set.employeeNavigation?.approachNavigation?.personal,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            approachNavigation: set.employeeNavigation?.approachNavigation?.clone(
                              personal: text,
                            ) ?? Approach.a().clone(
                              personal: text,
                            ),
                          ),
                        );
                      },
                    ),
                    TWSInputText(
                      label: "Alternative contact",
                      suffixLabel: ' opt.',
                      hint: "enter an alternative contact",
                      maxLength: 30,
                      controller: TextEditingController(
                        text: set.employeeNavigation?.approachNavigation?.alternative,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            approachNavigation: set.employeeNavigation?.approachNavigation?.clone(
                              alternative: text,
                            ) ?? Approach.a().clone(
                              alternative: text,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              if(set.employeeNavigation?.approachNavigation == null) 
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TWSCascadeSection(
                  title: "Contact", 
                  padding: EdgeInsets.zero,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  onPressed: (bool isShowing) {
                    //Creates a new approach object.
                    set = set.clone(
                      employeeNavigation: set.employeeNavigation?.clone(
                        approachNavigation: isShowing? Approach.a() : null,
                        approach: !isShowing? 0 : null,
                      ),
                    );
                  },
                  mainControl: const Expanded(
                    child: TWSDisplayFlat(
                      display: "Add a contact data",
                      color: TWSAColors.oceanBlue,
                      foreColor: TWSAColors.warmWhite,
                    ),
                  ),
                  content: CSMSpacingColumn(
                    spacing: 10,
                    children: <Widget>[
                      TWSInputText(
                        label: "Email",
                        hint: "Enter an email",
                        maxLength: 64,
                        controller: TextEditingController(
                          text: set.employeeNavigation?.approachNavigation?.email,
                        ),
                        onChanged: (String text) {
                          set = set.clone(
                            employeeNavigation: set.employeeNavigation?.clone(
                              approachNavigation: set.employeeNavigation?.approachNavigation?.clone(
                                email: text,
                              ) ?? Approach.a().clone(
                                email: text,
                              ),
                            ),
                          );
                        },
                      ),
                      TWSInputText(
                        label: "Entreprise phone",
                        suffixLabel: ' opt.',
                        hint: "enter an entreprise phone",
                        maxLength: 14,
                        controller: TextEditingController(
                          text: set.employeeNavigation?.approachNavigation?.enterprise,
                        ),
                        onChanged: (String text) {
                          set = set.clone(
                            employeeNavigation: set.employeeNavigation?.clone(
                              approachNavigation: set.employeeNavigation?.approachNavigation?.clone(
                                enterprise: text,
                              ) ?? Approach.a().clone(
                                enterprise: text,
                              ),
                            ),
                          );
                        },
                      ),
                      TWSInputText(
                        label: "Personal phone",
                        suffixLabel: ' opt.',
                        hint: "enter a personal phone",
                        maxLength: 16,
                        controller: TextEditingController(
                          text: set.employeeNavigation?.approachNavigation?.personal,
                        ),
                        onChanged: (String text) {
                          set = set.clone(
                            employeeNavigation: set.employeeNavigation?.clone(
                              approachNavigation: set.employeeNavigation?.approachNavigation?.clone(
                                personal: text,
                              ) ?? Approach.a().clone(
                                personal: text,
                              ),
                            ),
                          );
                        },
                      ),
                      TWSInputText(
                        label: "Alternative contact",
                        suffixLabel: ' opt.',
                        hint: "enter an alternative contact",
                        maxLength: 30,
                        controller: TextEditingController(
                          text: set.employeeNavigation?.approachNavigation?.alternative,
                        ),
                        onChanged: (String text) {
                          set = set.clone(
                            employeeNavigation: set.employeeNavigation?.clone(
                              approachNavigation: set.employeeNavigation?.approachNavigation?.clone(
                                alternative: text,
                              ) ?? Approach.a().clone(
                                alternative: text,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              if(set.employeeNavigation?.addressNavigation != null)
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
                      initialValue: set.employeeNavigation?.addressNavigation?.country == "" ? null :  set.employeeNavigation?.addressNavigation?.country,
                      displayValue:(String? item) => item ?? "Not valid data",
                      onChanged: (String? text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              country: text ?? '',
                              state: '',
                            ) ?? Address.a().clone(
                              country: text ?? '',
                              state: '',
                            ),
                          ),
                        );
                        _addressEffect();                        
                      },
                    ),
                    CSMDynamicWidget<_AddresState>(
                      state: _addresState, 
                      designer: (BuildContext ctx, _AddresState state) {
                        String? currentCountry = set.employeeNavigation?.addressNavigation?.country;
                        final String country = set.employeeNavigation?.addressNavigation?.country == _countryOptions[0]
                            ? _countryOptions[0]
                            : set.employeeNavigation?.addressNavigation?.country == _countryOptions[1]
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
                          initialValue: set.employeeNavigation?.addressNavigation?.state == "" ? null : set.employeeNavigation?.addressNavigation?.state,
                          displayValue:(String? item) => item ?? "Not valid data",
                          onChanged: (String? text) {
                            set = set.clone(
                              employeeNavigation: set.employeeNavigation?.clone(
                                addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                                  state: text ?? '',
                                ) ?? Address.a().clone(
                                  state: text ?? '',
                                ),
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
                        text: set.employeeNavigation?.addressNavigation?.street,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              street: text,
                            ) ?? Address.a().clone(
                              street: text,
                            ),
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
                        text: set.employeeNavigation?.addressNavigation?.altStreet,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              altStreet: text,
                            ) ?? Address.a().clone(
                              altStreet: text,
                            ),
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
                        text: set.employeeNavigation?.addressNavigation?.city,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              city: text,
                            ) ?? Address.a().clone(
                              city: text,
                            ),
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
                        text: set.employeeNavigation?.addressNavigation?.zip,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              zip: text,
                            ) ?? Address.a().clone(
                              zip: text,
                            ),
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
                        text: set.employeeNavigation?.addressNavigation?.colonia,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              colonia: text,
                            ) ?? Address.a().clone(
                              colonia: text,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              /// build a creation form.
              if(set.employeeNavigation?.addressNavigation == null) 
              TWSCascadeSection(
                title: "Address", 
                padding: EdgeInsets.zero,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                onPressed: (bool isShowing) {
                  //Creates a new address object.
                  set = set.clone(
                    employeeNavigation: set.employeeNavigation?.clone(
                      addressNavigation: isShowing? Address.a() : null,
                      address: 0,
                    )
                  );
                },
                mainControl: const Expanded(
                  child: TWSDisplayFlat(
                    display: "Add an address",
                    color: TWSAColors.oceanBlue,
                    foreColor: TWSAColors.warmWhite,
                  ),
                ),
                content: CSMSpacingColumn(
                  spacing: 10,
                  children: <Widget>[
                    TWSAutoCompleteField<String>(
                      width: double.maxFinite,
                      label: 'Country',
                      isOptional: true,
                      localList: _countryOptions,
                      initialValue: set.employeeNavigation?.addressNavigation?.country == "" ? null :  set.employeeNavigation?.addressNavigation?.country,
                      displayValue:(String? item) => item ?? "Not valid data",
                      onChanged: (String? text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              country: text ?? '',
                              state: '',
                            ) ?? Address.a().clone(
                              country: text ?? '',
                              state: '',
                            ),
                          ),
                        );
                        _addressEffect();                        
                      },
                    ),
                    CSMDynamicWidget<_AddresState>(
                      state: _addresState, 
                      designer: (BuildContext ctx, _AddresState state) {
                        String? currentCountry = set.employeeNavigation?.addressNavigation?.country;
                        final String country = set.employeeNavigation?.addressNavigation?.country == _countryOptions[0]
                            ? _countryOptions[0]
                            : set.employeeNavigation?.addressNavigation?.country == _countryOptions[1]
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
                          initialValue: set.employeeNavigation?.addressNavigation?.state == "" ? null : set.employeeNavigation?.addressNavigation?.state,
                          displayValue:(String? item) => item ?? "Not valid data",
                          onChanged: (String? text) {
                            set = set.clone(
                              employeeNavigation: set.employeeNavigation?.clone(
                                addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                                  state: text ?? '',
                                ) ?? Address.a().clone(
                                  state: text ?? '',
                                ),
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
                        text: set.employeeNavigation?.addressNavigation?.street,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              street: text,
                            ) ?? Address.a().clone(
                              street: text,
                            ),
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
                        text: set.employeeNavigation?.addressNavigation?.altStreet,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              altStreet: text,
                            ) ?? Address.a().clone(
                              altStreet: text,
                            ),
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
                        text: set.employeeNavigation?.addressNavigation?.city,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              city: text,
                            ) ?? Address.a().clone(
                              city: text,
                            ),
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
                        text: set.employeeNavigation?.addressNavigation?.zip,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              zip: text,
                            ) ?? Address.a().clone(
                              zip: text,
                            ),
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
                        text: set.employeeNavigation?.addressNavigation?.colonia,
                      ),
                      onChanged: (String text) {
                        set = set.clone(
                          employeeNavigation: set.employeeNavigation?.clone(
                            addressNavigation: set.employeeNavigation?.addressNavigation?.clone(
                              colonia: text,
                            ) ?? Address.a().clone(
                              colonia: text,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  @override
  Widget? composeViewer(Driver set, BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        child: CSMSpacingColumn(
          spacing: 10,
          children: <TWSPropertyViewer>[
            TWSPropertyViewer(
              label: "License number", 
              value: set.driverCommonNavigation?.license ?? "---",
            ),
            TWSPropertyViewer(
              label: "Name", 
              value: set.employeeNavigation?.identificationNavigation?.name ?? "---",
            ),
            TWSPropertyViewer(
              label: "Father lastname", 
              value: set.employeeNavigation?.identificationNavigation?.fatherlastname ?? "---",
            ),
            TWSPropertyViewer(
              label: "Mother lastname", 
              value: set.employeeNavigation?.identificationNavigation?.motherlastname ?? "---",
            ),
            TWSPropertyViewer(
              label: "Birthday", 
              value: set.employeeNavigation?.identificationNavigation?.birthday?.dateOnlyString ?? "---",
            ),
            TWSPropertyViewer(
              label: "Driver type", 
              value: set.licenseExpiration?.dateOnlyString ?? "---",
            ),
            TWSPropertyViewer(
              label: "Drugal reg. date", 
              value: set.drugalcRegistrationDate?.dateOnlyString ?? "---",
            ),
            TWSPropertyViewer(
              label: "Pull notice reg. date", 
              value: set.pullnoticeRegistrationDate?.dateOnlyString ?? "---",
            ),
            TWSPropertyViewer(
              label: "TWIC", 
              value: set.twic ?? "---",
            ),
            TWSPropertyViewer(
              label: "TWIC expiration", 
              value: set.twicExpiration?.dateOnlyString ?? "---",
            ),
            TWSPropertyViewer(
              label: "VISA number", 
              value: set.visa ?? "---",
            ),
            TWSPropertyViewer(
              label: "VISA Expiration", 
              value: set.visaExpiration?.dateOnlyString ?? "---",
            ),
            TWSPropertyViewer(
              label: "FAST number", 
              value: set.fast ?? "---",
            ),
            TWSPropertyViewer(
              label: "FAST Expiration", 
              value: set.fastExpiration?.dateOnlyString ?? "---",
            ),
            TWSPropertyViewer(
              label: "ANAM number", 
              value: set.anam ?? "---",
            ),
            TWSPropertyViewer(
              label: "ANAM Expiration", 
              value: set.anamExpiration?.dateOnlyString ?? "---",
            ),
            TWSPropertyViewer(
              label: "Country", 
              value: set.employeeNavigation?.addressNavigation?.country ?? "---",
            ),
            TWSPropertyViewer(
              label: "State", 
              value: set.employeeNavigation?.addressNavigation?.state ?? "---",
            ),
            TWSPropertyViewer(
              label: "Street", 
              value: set.employeeNavigation?.addressNavigation?.street ?? "---",
            ),
            TWSPropertyViewer(
              label: "Alt. street", 
              value: set.employeeNavigation?.addressNavigation?.altStreet ?? "---",
            ),
            TWSPropertyViewer(
              label: "City", 
              value: set.employeeNavigation?.addressNavigation?.city ?? "---",
            ),
            TWSPropertyViewer(
              label: "ZIP", 
              value: set.employeeNavigation?.addressNavigation?.zip ?? "---",
            ),
            TWSPropertyViewer(
              label: "Colonia", 
              value: set.employeeNavigation?.addressNavigation?.colonia ?? "---",
            ),
            TWSPropertyViewer(
              label: "Email", 
              value: set.employeeNavigation?.approachNavigation?.email ?? "---",
            ),
            TWSPropertyViewer(
              label: "Enterprise phone", 
              value: set.employeeNavigation?.approachNavigation?.enterprise ?? "---",
            ),
            TWSPropertyViewer(
              label: "Personal phone", 
              value: set.employeeNavigation?.approachNavigation?.personal ?? "---",
            ),
            TWSPropertyViewer(
              label: "Alternative contact", 
              value: set.employeeNavigation?.approachNavigation?.alternative ?? "---",
            ),
          ]
        ),
      ),
    );
  }

 

  
}