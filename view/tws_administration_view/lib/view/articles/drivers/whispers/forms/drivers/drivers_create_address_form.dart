part of '../../drivers_create_whisper.dart';

class _DriversCreateAddressForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;

  const _DriversCreateAddressForm({
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final Driver item = itemState!.model as Driver;
    return CSMSpacingColumn(
      spacing: 10,
      children: <Widget>[
        CSMSpacingRow(
          crossAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: <Widget>[
            Expanded(
              child: TWSAutoCompleteField<String>(
                isEnabled: enable,
                localList: _countryOptions,
                initialValue: item.employeeNavigation?.addressNavigation?.country == "" ? null :  item.employeeNavigation?.addressNavigation?.country,
                displayValue:(String? item) => item ?? "Not valid data",
                label: 'Country',
                isOptional: true,
                onChanged: (String? text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        addressNavigation: model.employeeNavigation?.addressNavigation?.clone(
                          country: text,
                        ) ?? Address.a().clone(
                          country: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        addressNavigation: Address.a().clone(
                          country: text,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TWSAutoCompleteField<String>(
                isEnabled: enable,
                label: 'State',
                suffixLabel: " opt.",
                isOptional: true,
                localList: const <String>[..._mxStateOptions, ..._usaStateOptions],
                displayValue: (String? query) => query ?? "---" ,
                initialValue: item.employeeNavigation?.addressNavigation?.state == "" ? null :  item.employeeNavigation?.addressNavigation?.state,
                onChanged: (String? text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        addressNavigation: model.employeeNavigation?.addressNavigation?.clone(
                          state: text,
                        ) ?? Address.a().clone(
                          country: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        addressNavigation: Address.a().clone(
                          country: text,
                        ),
                      ),
                    ),
                  );
                },              
              ),
            ),
          ],
        ),
        CSMSpacingRow(
          spacing: 10,
          children: <Widget>[
            Expanded(
              child: TWSInputText(
                maxLength: 100,
                label: 'Street',
                suffixLabel: ' opt.',
                isStrictLength: false,
                controller: TextEditingController(text: item.employeeNavigation?.addressNavigation?.street),
                onChanged: (String text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        addressNavigation: model.employeeNavigation?.addressNavigation?.clone(
                          street: text,
                        ) ?? Address.a().clone(
                          street: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        addressNavigation: Address.a().clone(
                          street: text,
                        ),
                      ),
                    ),
                  );
                },
                isEnabled: enable,
              ),
            ),
            Expanded(
              child: TWSInputText(
                maxLength: 100,
                label: 'Alt. street',
                suffixLabel: ' opt.',
                isStrictLength: false,
                controller: TextEditingController(text: item.employeeNavigation?.addressNavigation?.altStreet),
                onChanged: (String text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        addressNavigation: model.employeeNavigation?.addressNavigation?.clone(
                          altStreet: text,
                        ) ?? Address.a().clone(
                          altStreet: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        addressNavigation: Address.a().clone(
                          altStreet: text,
                        ),
                      ),
                    ),
                  );
                },
                isEnabled: enable,
              ),
            ),
          ]
        ),
        CSMSpacingRow(
          spacing: 10,
          children: <Widget>[
            Expanded(
              child: TWSInputText(
                maxLength: 30,
                label: 'City',
                suffixLabel: ' opt.',
                isStrictLength: false,
                controller: TextEditingController(text: item.employeeNavigation?.addressNavigation?.city),
                onChanged: (String text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        addressNavigation: model.employeeNavigation?.addressNavigation?.clone(
                          city: text,
                        ) ?? Address.a().clone(
                          city: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        addressNavigation: Address.a().clone(
                          city: text,
                        ),
                      ),
                    ),
                  );
                },
                isEnabled: enable,
              ),
            ),
            Expanded(
              child: TWSInputText(
                maxLength: 5,
                label: 'ZIP',
                suffixLabel: ' opt.',
                isStrictLength: false,
                controller: TextEditingController(text: item.employeeNavigation?.addressNavigation?.zip),
                onChanged: (String text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        addressNavigation: model.employeeNavigation?.addressNavigation?.clone(
                          zip: text,
                        ) ?? Address.a().clone(
                          zip: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        addressNavigation: Address.a().clone(
                          zip: text,
                        ),
                      ),
                    ),
                  );
                },
                isEnabled: enable,
              ),
            ),
          ]
        ),
        CSMSpacingRow(
          spacing: 10,
          children: <Widget>[
            Expanded(
              child: TWSInputText(
                maxLength: 30,
                label: 'Colonia',
                suffixLabel: ' opt.',
                isStrictLength: false,
                controller: TextEditingController(text: item.employeeNavigation?.addressNavigation?.colonia),
                onChanged: (String text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        addressNavigation: model.employeeNavigation?.addressNavigation?.clone(
                          colonia: text,
                        ) ?? Address.a().clone(
                          colonia: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        addressNavigation: Address.a().clone(
                          colonia: text,
                        ),
                      ),
                    ),
                  );
                },
                isEnabled: enable,
              ),
            ),
          ]
        ),
      ],
    );
  }
}
