part of '../trailers_create_whisper.dart';

class _TrailerExternalForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool formDisabled;
  final TextStyle style;
  final TrailerExternal item;
  const _TrailerExternalForm({
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
                maxLength: 16,
                label: 'Economic',
                isStrictLength: false,
                controller: TextEditingController(
                    text: item.trailerCommonNavigation?.economic),
                onChanged: (String text) {
                  TrailerExternal model = itemState!.model as TrailerExternal;
                  itemState!.updateModelRedrawing(
                    model.clone(
                      trailerCommonNavigation:
                          model.trailerCommonNavigation?.clone(economic: text) ??
                              TrailerCommon.a().clone(economic: text),
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
                maxLength: 12,
                label: 'MX Plate',
                isStrictLength: false,
                controller: TextEditingController(text: item.mxPlate),
                onChanged: (String text) {
                  TrailerExternal model = itemState!.model as TrailerExternal;
                  itemState!.updateModelRedrawing(
                    model.clone(
                      mxPlate: text,
                    ),
                  );
                },
                isEnabled: formDisabled,
              ),
            ),
            Expanded(
              child: TWSInputText(
                maxLength: 12,
                label: 'USA Plate',
                isStrictLength: false,
                controller: TextEditingController(text: item.usaPlate),
                onChanged: (String text) {
                  TrailerExternal model = itemState!.model as TrailerExternal;
                  itemState!.updateModelRedrawing(
                    model.clone(
                      usaPlate: text,
                    ),
                  );
                },
                isEnabled: formDisabled,
              ),
            ),
          ],
        ),
        CSMSpacingRow(spacing: 10, children: <Widget>[
          Expanded(
            child: TWSInputText(
              maxLength: 100,
              label: 'Carrier',
              isStrictLength: false,
              controller: TextEditingController(text: item.carrier),
              onChanged: (String text) {
                TrailerExternal model = itemState!.model as TrailerExternal;
                itemState!.updateModelRedrawing(
                  model.clone(
                    carrier: text,
                  ),
                );
              },
              isEnabled: formDisabled,
            ),
          ),
        ]),
         CSMDynamicWidget<_TrailersCreateTypeState>(
      state: _typeformState,
      designer: (BuildContext context, _TrailersCreateTypeState state) {
        final TrailerExternal item = itemState!.model as TrailerExternal;
        final bool isEnable = itemState != null &&  (item.trailerCommonNavigation?.trailerTypeNavigation?.id == 0 || item.trailerCommonNavigation?.type == null);

        return TWSCascadeSection(
              title: "Trailer Configuration", 
              onPressed: (bool isShowing) {
                if(isShowing){
                  TrailerExternal model = itemState!.model as TrailerExternal;
                  itemState!.updateModelRedrawing(
                    model.clone(
                      trailerCommonNavigation: model.trailerCommonNavigation?.clone(
                        type:  0,
                      ),
                    ),
                  );
                  state.effect();
                }
                
              },
              mainControl: Expanded(
                child: TWSAutoCompleteField<TrailerType>(
                  label: "Select a configuration",
                  hint: "Select a configuration",
                  isOptional: true,
                  initialValue: item.trailerCommonNavigation?.trailerTypeNavigation,
                  adapter: const _TrailerTypeViewAdapter(),
                  hasKeyValue: (TrailerType? set) {
                    if(set?.id != null) return set!.id > 0;
                    return false;
                  },
                  onChanged: (TrailerType? selectedItem){
                    TrailerExternal model = itemState!.model as TrailerExternal;
                    itemState!.updateModelRedrawing(
                      model.clone(
                        trailerCommonNavigation: model.trailerCommonNavigation?.clone(
                          trailerTypeNavigation: selectedItem,
                          type: selectedItem?.id ?? 0,
                        ) ?? TrailerCommon.a().clone(
                          trailerTypeNavigation: selectedItem,
                          type: selectedItem?.id ?? 0,
                        ),
                      )
                    );
                    state.effect();
                  }, 
                  displayValue: (TrailerType? set){
                    if(set?.size != null && set?.trailerClassNavigation?.name != null) return "${set?.trailerClassNavigation?.name} - ${set?.size}";
                    return "---";
                  }
                ),
              ), 
            content: CSMSpacingColumn(
            spacing: 10,
            children: <Widget>[
              CSMSpacingRow(
                crossAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: <Widget>[
                  Expanded(
                    child: TWSInputText(
                      maxLength: 20,
                      label: 'Size',
                      hint: "40FT.. 48FT..",
                      isStrictLength: false,
                      isEnabled: isEnable,
                      controller: TextEditingController(text: item.trailerCommonNavigation?.trailerTypeNavigation?.size),
                      onChanged: (String text) {
                        TrailerExternal model = itemState!.model as TrailerExternal;
                        itemState!.updateModelRedrawing(
                          model.clone(
                            trailerCommonNavigation: model.trailerCommonNavigation?.clone(
                              trailerTypeNavigation: model.trailerCommonNavigation?.trailerTypeNavigation?.clone(size: text) ?? TrailerType.def().clone(size: text)
                            )
                            ?? TrailerCommon.a().clone(trailerTypeNavigation: TrailerType.def().clone(size: text))
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: TWSAutoCompleteField<TrailerClass>(
                      label: "Select a Type",
                      hint: "Select a Type",
                      isOptional: true,
                      initialValue: item.trailerCommonNavigation?.trailerTypeNavigation?.trailerClassNavigation,
                      adapter: const _TrailerClassViewAdapter(),
                      isEnabled: isEnable,
                      onChanged: (TrailerClass? selectedItem){
                        TrailerExternal model = itemState!.model as TrailerExternal;
                        itemState!.updateModelRedrawing(
                          model.clone(
                            trailerCommonNavigation: model.trailerCommonNavigation?.clone(
                              trailerTypeNavigation: model.trailerCommonNavigation?.trailerTypeNavigation?.clone(
                                trailerClassNavigation: selectedItem,
                                trailerClass: selectedItem?.id ?? 0,
                              ) ?? TrailerType.def().clone(
                                trailerClassNavigation: selectedItem,
                                trailerClass: selectedItem?.id ?? 0,
                              ),
                            )
                            ?? TrailerCommon.a().clone(trailerTypeNavigation: TrailerType.def().clone(
                              trailerClassNavigation: selectedItem,
                              trailerClass: selectedItem?.id ?? 0,
                            )),
                          ),
                        );
                        state.effect();
                      }, 
                      displayValue: (TrailerClass? set){
                        return set?.name ?? "invalid value";
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
      ],
    );
  }
}
