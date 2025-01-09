part of '../../drivers_create_whisper.dart';

class _DriversCreateMainForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;

  const _DriversCreateMainForm({
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final Driver item = itemState!.model as Driver;
    return CSMSpacingColumn(spacing: 10, children: <Widget>[
      CSMSpacingRow(
        spacing: 10,
        children: <Widget>[
          Expanded(
            child: TWSInputText(
              maxLength: 12,
              isStrictLength: true,
              label: 'License',
              controller: TextEditingController(
                text: item.driverCommonNavigation?.license,
              ),
              onChanged: (String text) {
                Driver model = itemState!.model as Driver;
                itemState?.updateModelRedrawing(
                  model.clone(
                    driverCommonNavigation: model.driverCommonNavigation?.clone(
                          license: text,
                        ) ??
                        DriverCommon.a().clone(
                          license: text,
                        ),
                  ),
                );
              },
              isEnabled: enable,
            ),
          ),
        ],
      ),
      TWSSection(
        padding: const EdgeInsets.symmetric(vertical: 20),
        title: 'Optional data',
        content: CSMSpacingColumn(
          spacing: 10,
          children: <Widget>[
            CSMSpacingRow(
              spacing: 10,
              children: <Widget>[
                Expanded(
                  child: TWSAutoCompleteField<Situation>(
                    width: double.maxFinite,
                    adapter: const _SituationsViewAdapter(),
                    initialValue: item.driverCommonNavigation?.situationNavigation,
                    isEnabled: true,
                    isOptional: true,
                    displayValue: (Situation? item) => item?.name ?? "Not valid data",
                    label: 'Situation',
                    onChanged: (Situation? value) {
                      Driver model = itemState!.model as Driver;
                      itemState?.updateModelRedrawing(
                        model.clone(
                          driverCommonNavigation:model.driverCommonNavigation?.clone(
                            situationNavigation: value,
                            situation: value?.id ?? 0,
                          ) ??
                          DriverCommon.a().clone(
                            situationNavigation: value,
                            situation: value?.id,
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
                    maxLength: 16,
                    label: 'Driver type',
                    isStrictLength: false,
                    controller: TextEditingController(text: item.driverType),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState?.updateModelRedrawing(
                        model.clone(driverType: text),
                      );
                    },
                    isEnabled: enable,
                  ),
                ),
                Expanded(
                  child: TWSDatepicker(
                    firstDate: _firstDate,
                    lastDate: _lastlDate,
                    label: 'License expiration',
                    controller: TextEditingController(
                      text: item.licenseExpiration?.toIso8601String(),
                    ),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;

                      itemState!.updateModelRedrawing(
                        model.clone(
                            licenseExpiration:
                                DateTime.tryParse(text) ?? DateTime(0)),
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
                  child: TWSDatepicker(
                    firstDate: _firstDate,
                    lastDate: _lastlDate,
                    label: 'Drugal reg. date',
                    controller: TextEditingController(
                        text: item.drugalcRegistrationDate?.toIso8601String()),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState!.updateModelRedrawing(
                        model.clone(
                            drugalcRegistrationDate:
                                DateTime.tryParse(text) ?? DateTime(0)),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: TWSDatepicker(
                    firstDate: _firstDate,
                    lastDate: _lastlDate,
                    label: 'Pull notice reg. date',
                    controller: TextEditingController(
                        text:
                            item.pullnoticeRegistrationDate?.toIso8601String()),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState!.updateModelRedrawing(
                        model.clone(
                            pullnoticeRegistrationDate:
                                DateTime.tryParse(text) ?? DateTime(0)),
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
                    maxLength: 12,
                    label: 'TWIC number',
                    isStrictLength: true,
                    controller: TextEditingController(text: item.twic),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState?.updateModelRedrawing(
                        model.clone(twic: text),
                      );
                    },
                    isEnabled: enable,
                  ),
                ),
                Expanded(
                  child: TWSDatepicker(
                    firstDate: _firstDate,
                    lastDate: _lastlDate,
                    label: 'TWIC expiration',
                    controller: TextEditingController(
                      text: item.twicExpiration?.toIso8601String(),
                    ),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState!.updateModelRedrawing(
                        model.clone(
                            twicExpiration:
                                DateTime.tryParse(text) ?? DateTime(0)),
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
                    maxLength: 12,
                    label: 'VISA number',
                    isStrictLength: true,
                    controller: TextEditingController(text: item.visa),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState?.updateModelRedrawing(
                        model.clone(visa: text),
                      );
                    },
                    isEnabled: enable,
                  ),
                ),
                Expanded(
                  child: TWSDatepicker(
                    firstDate: _firstDate,
                    lastDate: _lastlDate,
                    label: 'VISA expiration',
                    controller: TextEditingController(
                      text: item.visaExpiration?.toIso8601String(),
                    ),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState!.updateModelRedrawing(
                        model.clone(
                            visaExpiration:
                                DateTime.tryParse(text) ?? DateTime(0)),
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
                    maxLength: 14,
                    label: 'FAST number',
                    isStrictLength: true,
                    controller: TextEditingController(text: item.fast),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState?.updateModelRedrawing(
                        model.clone(fast: text),
                      );
                    },
                    isEnabled: enable,
                  ),
                ),
                Expanded(
                  child: TWSDatepicker(
                    firstDate: _firstDate,
                    lastDate: _lastlDate,
                    label: 'FAST expiration',
                    controller: TextEditingController(
                      text: item.fastExpiration?.toIso8601String(),
                    ),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState!.updateModelRedrawing(
                        model.clone(
                            fastExpiration:
                                DateTime.tryParse(text) ?? DateTime(0)),
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
                    maxLength: 24,
                    label: 'ANAM number',
                    isStrictLength: true,
                    controller: TextEditingController(text: item.anam),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState?.updateModelRedrawing(
                        model.clone(anam: text),
                      );
                    },
                    isEnabled: enable,
                  ),
                ),
                Expanded(
                  child: TWSDatepicker(
                    firstDate: _firstDate,
                    lastDate: _lastlDate,
                    label: 'ANAM expiration',
                    controller: TextEditingController(
                      text: item.anamExpiration?.toIso8601String(),
                    ),
                    onChanged: (String text) {
                      Driver model = itemState!.model as Driver;
                      itemState!.updateModelRedrawing(
                        model.clone(
                            anamExpiration:
                                DateTime.tryParse(text) ?? DateTime(0)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
