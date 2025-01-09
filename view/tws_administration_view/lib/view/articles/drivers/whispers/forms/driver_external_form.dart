part of '../drivers_create_whisper.dart';

class _DriversExternalForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool formDisabled;
  final TextStyle style;
  final DriverExternal item;
  const _DriversExternalForm({
    required this.style,
    required this.item,
    this.itemState,
    this.formDisabled = true,
  });
  @override
  Widget build(BuildContext context) {
    return CSMSpacingColumn(
      mainSize: MainAxisSize.min,
      spacing: 12,
      crossAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CSMSpacingRow(
          spacing: 10,
          children: <Widget>[
            Expanded(
              child: TWSInputText(
                maxLength: 12,
                label: 'Licencese',
                isStrictLength: false,
                controller: TextEditingController(
                    text: item.driverCommonNavigation?.license),
                onChanged: (String text) {
                  DriverExternal model = itemState!.model as DriverExternal;
                  itemState!.updateModelRedrawing(
                    model.clone(
                      driverCommonNavigation: model.driverCommonNavigation?.clone(
                        license: text,
                      ) ??
                      DriverCommon.a().clone(
                        license: text,
                      )
                    ),
                  );
                },
                isEnabled: formDisabled,
              ),
            ),
            Expanded(
              child: TWSInputText(
                maxLength: 17,
                label: 'Name',
                isStrictLength: true,
                controller: TextEditingController(text: item.identificationNavigation?.name),
                onChanged: (String text) {
                  DriverExternal model = itemState!.model as DriverExternal;
                    itemState?.updateModelRedrawing(
                      model.clone(
                        identificationNavigation: model.identificationNavigation?.clone(
                          name: text,
                        ) ??
                        Identification.a().clone(
                          name: text,
                        ),
                      ),
                    );
                },
                isEnabled: formDisabled,
              ),
            ),
          ],
        ),
        CSMSpacingRow(
          spacing: 10,
          children: <Widget>[
            Expanded(
              child: TWSInputText(
                maxLength: 32,
                label: 'Father lastname',
                isStrictLength: false,
                controller: TextEditingController(text: item.identificationNavigation?.fatherlastname),
                onChanged: (String text) {
                  DriverExternal model = itemState!.model as DriverExternal;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      identificationNavigation: model.identificationNavigation?.clone(
                        fatherlastname: text,
                      ) ??
                      Identification.a().clone(
                        fatherlastname: text,
                      ),
                    ),
                  );
                },
                isEnabled: formDisabled,
              ),
            ),
            Expanded(
              child: TWSInputText(
                maxLength: 32,
                label: 'Mother lastname',
                isStrictLength: false,
                controller: TextEditingController(text: item.identificationNavigation?.motherlastname),
                onChanged: (String text) {
                  DriverExternal model = itemState!.model as DriverExternal;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      identificationNavigation: model.identificationNavigation?.clone(
                        motherlastname: text,
                      ) ??
                      Identification.a().clone(
                        motherlastname: text,
                      ),
                    ),
                  );
                },
                isEnabled: formDisabled,
              ),
            ),
          ]
        ),
        CSMSpacingRow(
          spacing: 10,
          children: <Widget>[
            Expanded(
              child: TWSDatepicker(
                firstDate: _firstDate,
                lastDate: _lastlDate,
                label: 'Birthday',
                suffixLabel: " opt.",
                controller: TextEditingController(text: item.identificationNavigation?.birthday?.toIso8601String()),
                onChanged: (String text) {
                  DriverExternal model = itemState!.model as DriverExternal;
                  itemState?.updateModelRedrawing(
                    model.clone(
                      identificationNavigation: model.identificationNavigation?.clone(
                        birthday: DateTime.tryParse(text) ?? DateTime(0),
                      ) ??
                      Identification.a().clone(
                        birthday: DateTime.tryParse(text) ?? DateTime(0),
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
