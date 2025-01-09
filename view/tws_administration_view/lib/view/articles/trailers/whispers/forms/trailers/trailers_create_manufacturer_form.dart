part of '../../trailers_create_whisper.dart';

class _TrailersCreateMaintenanceState extends CSMStateBase{}
final _TrailersCreateMaintenanceState _maintenanceformState = _TrailersCreateMaintenanceState();

class _TrailersCreateManufacturer extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;
  final TextStyle style;
  const _TrailersCreateManufacturer({
    required this.style,
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return CSMDynamicWidget<_TrailersCreateMaintenanceState>(
      state: _maintenanceformState,
      designer: (_, _TrailersCreateMaintenanceState state){
        final Trailer item = itemState!.model as Trailer;
        final bool isEnable = itemState != null &&  (item.vehiculeModelNavigation?.id == 0 || item.vehiculeModelNavigation == null);
        
        return TWSCascadeSection(
          title: "Trailer Model", 
          onPressed: (bool isShowing) {
            if(isShowing) {
              Trailer model = itemState!.model as Trailer;
              itemState!.updateModelRedrawing(
                model.clone(
                  model: 0
                )
              );
              state.effect();
            }
          },
          mainControl: Expanded(
            child: TWSAutoCompleteField<VehiculeModel>(
              label: "Select a Model",
              hint: "Select a Model",
              isOptional: true,
              initialValue: item.vehiculeModelNavigation,
              adapter: const _VehiculeModelViewAdapter(),
              hasKeyValue: (VehiculeModel? set) {
                if(set?.id != null) return set!.id > 0;
                return false;
              },
              onChanged: (VehiculeModel? selectedItem){
                Trailer model = itemState!.model as Trailer;
                itemState!.updateModelRedrawing(
                  model.clone(
                    vehiculeModelNavigation: selectedItem,
                    model: selectedItem?.id ?? 0
                  )
                );
                state.effect();
              }, 
              displayValue: (VehiculeModel? set){
                return _displayModel(set);
              }
            ),
          ), 
          content: CSMSpacingColumn(
            spacing: 10,
            children: <Widget>[
              const TWSSectionDivider(
                color: Colors.white, 
                text: "Create a Model"
              ),
              CSMSpacingRow(
                crossAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: <Widget>[
                  Expanded(
                    child: TWSAutoCompleteField<Manufacturer>(
                      adapter: const _ManufacturersViewAdapter(),
                      label: "Select a Brand",
                      hint: "Select a brand",
                      isOptional: true,
                      isEnabled: isEnable,
                      initialValue: item.vehiculeModelNavigation?.manufacturerNavigation,
                      onChanged:(Manufacturer? selection) {
                        Trailer model = itemState!.model as Trailer;
                        itemState!.updateModelRedrawing(
                          model.clone(
                            vehiculeModelNavigation: model.vehiculeModelNavigation?.clone(
                              manufacturer: selection?.id ?? 0,
                              manufacturerNavigation: selection
                            ) ?? VehiculeModel.def().clone(
                              manufacturer: selection?.id ?? 0,
                              manufacturerNavigation: selection
                            )
                          )
                        );
                      }, 
                      displayValue:(Manufacturer? set) {
                        return set?.name ?? "not valid data";
                      },
                    )
                  ),
                  Expanded(
                    child: TWSInputText(
                      label: 'Model',
                      maxLength: 30,
                      isEnabled: isEnable,
                      controller: TextEditingController(text: item.vehiculeModelNavigation?.name),
                      onChanged: (String text) {
                        Trailer model = itemState!.model as Trailer;
                        itemState!.updateModelRedrawing(
                          model.clone(
                            vehiculeModelNavigation: model.vehiculeModelNavigation?.clone(name: text) ?? VehiculeModel.def().clone(name: text)
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
                    child: TWSDatepicker(
                      firstDate: _firstDate,
                      lastDate: _lastlDate,
                      label: 'Year',
                      isEnabled: isEnable,
                      controller: TextEditingController(text: item.vehiculeModelNavigation?.year.dateOnlyString ?? _today.dateOnlyString),
                      onChanged: (String text) {
                        Trailer model = itemState!.model as Trailer;
                        itemState!.updateModelRedrawing(
                          model.clone(
                            vehiculeModelNavigation: model.vehiculeModelNavigation?.clone(
                              year: DateTime.tryParse(text)
                            ) ?? VehiculeModel.def().clone(year: DateTime.tryParse(text))
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}