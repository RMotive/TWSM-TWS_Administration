part of '../../trucks_create_whisper.dart';

class _TruckCreateMainForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;

  const _TruckCreateMainForm({
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final Truck item = itemState!.model as Truck;
    return CSMSpacingColumn(spacing: 10, children: <Widget>[
      CSMSpacingRow(
        spacing: 10,
        children: <Widget>[
          Expanded(
            child: TWSInputText(
              maxLength: 17,
              isStrictLength: true,
              label: 'VIN',
              controller: TextEditingController(text: item.vin),
              onChanged: (String text) {
                Truck model = itemState!.model as Truck;
                itemState!.updateModelRedrawing(
                  model.clone(
                    vin: text,
                  ),
                );
              },
              isEnabled: enable,
            ),
          ),
          Expanded(
            child: TWSInputText(
              maxLength: 16,
              label: 'Motor',
              isStrictLength: true,
              controller: TextEditingController(text: item.motor),
              onChanged: (String text) {
                Truck model = itemState!.model as Truck;
                itemState!.updateModelRedrawing(
                  model.clone(
                    motor: text,
                  ),
                );
              },
              isEnabled: enable,
            ),
          ),
        ],
      ),
      CSMSpacingRow(
        spacing: 10,
        children: <Widget>[
          Expanded(
            child: TWSAutoCompleteField<Carrier>(
              label: "Select a Carrier",
              hint: "Select a carrier",
              isOptional: true,
              hasKeyValue: (Carrier? set) {
                if (set?.id != null) return true;
                return false;
              },
              adapter: const _CarriersViewAdapter(),
              initialValue: item.carrierNavigation,
              onChanged: (Carrier? selectedItem) {
                Truck model = itemState!.model as Truck;
                itemState!.updateModelRedrawing(model.clone(
                  carrier: selectedItem?.id ?? 0,
                  carrierNavigation: selectedItem,
                ));
              },
              displayValue: (Carrier? set) {
                return set?.name ?? 'Not valid';
              },
            ),
          ),
          Expanded(
            child: TWSInputText(
              maxLength: 16,
              label: 'Economic',
              isStrictLength: false,
              controller: TextEditingController(
                  text: item.truckCommonNavigation?.economic),
              onChanged: (String text) {
                Truck model = itemState!.model as Truck;
                itemState!.updateModelRedrawing(
                  model.clone(
                    truckCommonNavigation:
                        model.truckCommonNavigation?.clone(economic: text) ??
                            TruckCommon.a().clone(economic: text),
                  ),
                );
              },
              isEnabled: enable,
            ),
          ),
        ],
      ),
    ]);
  }
}
