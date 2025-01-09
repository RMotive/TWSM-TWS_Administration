part of '../../drivers_create_whisper.dart';

class _DriversCreateApproachForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;

  const _DriversCreateApproachForm({
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
          spacing: 10,
          children: <Widget>[
            Expanded(
              child: TWSInputText(
                isEnabled: enable,                
                maxLength: 64,
                label: 'email',
                isStrictLength: false,
                controller: TextEditingController(text: item.employeeNavigation?.approachNavigation?.email),
                onChanged: (String text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        approachNavigation: model.employeeNavigation?.approachNavigation?.clone(
                          email: text,
                        ) ?? Approach.a().clone(
                          email: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        approachNavigation: Approach.a().clone(
                          email: text,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TWSInputText(
                isEnabled: enable,
                maxLength: 14,
                label: 'Enterprise phone',
                suffixLabel: ' opt.',
                isStrictLength: false,
                controller: TextEditingController(text: item.employeeNavigation?.approachNavigation?.enterprise),
                onChanged: (String text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        approachNavigation: model.employeeNavigation?.approachNavigation?.clone(
                          enterprise: text,
                        ) ?? Approach.a().clone(
                          enterprise: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        approachNavigation: Approach.a().clone(
                          enterprise: text,
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
                isEnabled: enable,
                maxLength: 13,
                label: 'Personal phone',
                suffixLabel: ' opt.',
                isStrictLength: false,
                controller: TextEditingController(text: item.employeeNavigation?.approachNavigation?.personal),
                onChanged: (String text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        approachNavigation: model.employeeNavigation?.approachNavigation?.clone(
                          personal: text,
                        ) ?? Approach.a().clone(
                          personal: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        approachNavigation: Approach.a().clone(
                          personal: text,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TWSInputText(
                isEnabled: enable,
                maxLength: 30,
                label: 'Alternative contact',
                suffixLabel: ' opt.',
                isStrictLength: false,
                controller: TextEditingController(text: item.employeeNavigation?.approachNavigation?.alternative),
                onChanged: (String text) {
                  Driver model = itemState!.model as Driver;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      employeeNavigation: model.employeeNavigation?.clone(
                        approachNavigation: model.employeeNavigation?.approachNavigation?.clone(
                          alternative: text,
                        ) ?? Approach.a().clone(
                          alternative: text,
                        ),
                      ) ??
                      Employee.a().clone(
                        approachNavigation: Approach.a().clone(
                          alternative: text,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]
        ),
      ],
    );
  }
}
