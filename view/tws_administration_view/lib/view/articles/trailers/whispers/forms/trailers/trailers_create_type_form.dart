part of '../../trailers_create_whisper.dart';
class _TrailersCreateTypeState extends CSMStateBase{}
final _TrailersCreateTypeState _typeformState = _TrailersCreateTypeState();

class _TrailerCreateType extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;
  const _TrailerCreateType({
    this.itemState,
    this.enable = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return CSMDynamicWidget<_TrailersCreateTypeState>(
      state: _typeformState,
      designer: (BuildContext context, _TrailersCreateTypeState state) {
        final Trailer item = itemState!.model as Trailer;
        final bool isEnable = itemState != null &&  (item.trailerCommonNavigation?.trailerTypeNavigation?.id == 0 || item.trailerCommonNavigation?.type == null);
        return TWSCascadeSection(
          title: "Trailer Configuration", 
          onPressed: (bool isShowing) {
            if(isShowing) {
              Trailer model = itemState!.model as Trailer;
              itemState!.updateModelRedrawing(
                model.clone(
                  trailerCommonNavigation: model.trailerCommonNavigation?.clone(
                    type: 0
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
                Trailer model = itemState!.model as Trailer;
                itemState!.updateModelRedrawing(
                  model.clone(
                    trailerCommonNavigation: model.trailerCommonNavigation?.clone(
                      trailerTypeNavigation: selectedItem,
                      type: selectedItem?.id ?? 0,
                    ) ?? TrailerCommon.a().clone(
                      trailerTypeNavigation: selectedItem,
                      type: selectedItem?.id ?? 0,
                    ),
                  ),
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
                        Trailer model = itemState!.model as Trailer;
                        itemState!.updateModelRedrawing(
                          model.clone(
                            trailerCommonNavigation: model.trailerCommonNavigation?.clone(
                              trailerTypeNavigation: model.trailerCommonNavigation?.trailerTypeNavigation?.clone(size: text) ?? TrailerType.def().clone(size: text),
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
                        Trailer model = itemState!.model as Trailer;
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
    );
  }
}