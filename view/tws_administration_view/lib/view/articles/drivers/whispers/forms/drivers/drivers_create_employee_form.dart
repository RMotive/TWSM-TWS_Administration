part of '../../drivers_create_whisper.dart';

class _EmployeeCreationState extends CSMStateBase { }
final _EmployeeCreationState _employeeState = _EmployeeCreationState();

class _DriversCreateEmployeeForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;

  const _DriversCreateEmployeeForm({
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return CSMDynamicWidget<_EmployeeCreationState>(
        state: _employeeState,
        designer: (BuildContext context, _EmployeeCreationState state) {
          final Driver item = itemState!.model as Driver;
          final bool isEnable = itemState != null &&  (item.employeeNavigation?.id == 0 || item.employeeNavigation?.id == null);
          return TWSCascadeSection(
            title: "Employee", 
            mainControl: Expanded(
              child: TWSAutoCompleteField<Employee>(
                label: 'Select an employee',
                isOptional: true,
                adapter: const _EmployeeViewAdapter(),
                initialValue: item.employeeNavigation,
                hasKeyValue: (Employee? item) {
                  if(item?.id != null) return item!.id > 0;
                  return false;
                },
                displayValue: (Employee? item) {
                  Identification? identification = item?.identificationNavigation;
                  return identification != null? "${identification.name} ${identification.fatherlastname} ${identification.motherlastname}" : "Unexpected value";
                },
                onChanged: (Employee? value) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employee: value?.id ?? 0,
                      employeeNavigation: value,
                    ),
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
                text: "Create an Employee"
              ),
              CSMSpacingRow(
                spacing: 10,
                children: <Widget>[
                  Expanded(
                    child: TWSInputText(
                      isEnabled: isEnable,
                      maxLength: 32,
                      label: 'Name',
                      isStrictLength: false,
                      controller: TextEditingController(text: item.employeeNavigation?.identificationNavigation?.name),
                      onChanged: (String text) {
                        Driver model = itemState!.model as Driver;
                        itemState?.updateModelRedrawing(
                          model.clone(
                            employeeNavigation: model.employeeNavigation?.clone(
                              identificationNavigation: model.employeeNavigation?.identificationNavigation?.clone(
                                name: text,
                              ) ?? Identification.a().clone(
                                name: text,
                              ),
                            ) ??
                            Employee.a().clone(
                              identificationNavigation: Identification.a().clone(
                                name: text,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: TWSInputText(
                      isEnabled: isEnable,
                      maxLength: 32,
                      label: 'Father lastname',
                      isStrictLength: false,
                      controller: TextEditingController(text: item.employeeNavigation?.identificationNavigation?.fatherlastname),
                      onChanged: (String text) {
                        Driver model = itemState!.model as Driver;
                        itemState?.updateModelRedrawing(
                          model.clone(
                            employeeNavigation: model.employeeNavigation?.clone(
                              identificationNavigation: model.employeeNavigation?.identificationNavigation?.clone(
                                fatherlastname: text,
                              ) ?? Identification.a().clone(
                                fatherlastname: text,
                              ),
                            ) ??
                            Employee.a().clone(
                              identificationNavigation: Identification.a().clone(
                                fatherlastname: text,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]
              ),
              CSMSpacingRow(
                spacing: 10,
                children: <Widget>[
                  Expanded(
                    child: TWSInputText(
                      isEnabled: isEnable,
                      maxLength: 32,
                      label: 'Mother lastname',
                      isStrictLength: false,
                      controller: TextEditingController(text: item.employeeNavigation?.identificationNavigation?.motherlastname),
                      onChanged: (String text) {
                        Driver model = itemState!.model as Driver;
                        itemState?.updateModelRedrawing(
                          model.clone(
                            employeeNavigation: model.employeeNavigation?.clone(
                              identificationNavigation: model.employeeNavigation?.identificationNavigation?.clone(
                                motherlastname: text,
                              ) ?? Identification.a().clone(
                                motherlastname: text,
                              ),
                            ) ??
                            Employee.a().clone(
                              identificationNavigation: Identification.a().clone(
                                motherlastname: text,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: TWSDatepicker(
                      isEnabled: isEnable,
                      firstDate: _firstDate,
                      lastDate: _lastlDate,
                      label: 'Birthday',
                      suffixLabel: ' opt.',
                      controller: TextEditingController(text: item.employeeNavigation?.identificationNavigation?.birthday?.toIso8601String()),
                      onChanged: (String text) {
                        Driver model = itemState!.model as Driver;
                        itemState?.updateModelRedrawing(
                          model.clone(
                            employeeNavigation: model.employeeNavigation?.clone(
                              identificationNavigation: model.employeeNavigation?.identificationNavigation?.clone(
                                birthday: DateTime.tryParse(text) ?? DateTime(0),
                              ) ?? Identification.a().clone(
                                birthday: DateTime.tryParse(text) ?? DateTime(0),
                              ),
                            ) ??
                            Employee.a().clone(
                              identificationNavigation: Identification.a().clone(
                                birthday: DateTime.tryParse(text) ?? DateTime(0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]
              ),
              const TWSSectionDivider(
                color: Colors.white, 
                text: "Add Address (optional)"
              ),
              _DriversCreateAddressForm(
                itemState: itemState,
                enable: isEnable,
              ),
              const TWSSectionDivider(
                color: Colors.white, 
                text: "Add Contact data (optional)"
              ),
              _DriversCreateApproachForm(
                itemState: itemState,
                enable: isEnable,
              ),
            ],
          ));
        }
    );
  }
}
