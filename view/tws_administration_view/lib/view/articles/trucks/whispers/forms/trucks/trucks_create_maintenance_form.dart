part of '../../trucks_create_whisper.dart';

class _TruckCreateMaintenance extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;
  const _TruckCreateMaintenance({
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final Truck item = itemState!.model as Truck;
    return TWSSection(
      isOptional: true,
      padding: const EdgeInsets.symmetric(vertical: 10),
      title: "Maintenance (optional)",
      content: CSMSpacingColumn(spacing: 10, children: <Widget>[
        CSMSpacingRow(spacing: 10, children: <Widget>[
          Expanded(
            child: TWSDatepicker(
              firstDate: _firstDate,
              lastDate: _lastlDate,
              label: 'Anual',
              controller: TextEditingController(text: item.maintenanceNavigation?.anual.dateOnlyString),
              onChanged: (String text) {
                Truck model = itemState!.model as Truck;
                DateTime date = DateTime.tryParse(text) ?? DateTime(0);
                itemState!.updateModelRedrawing(
                  model.clone(
                    maintenanceNavigation: model.maintenanceNavigation?.clone(anual: date) 
                    ?? Maintenance.a().clone(anual: date)
                  ),
                );
                model = itemState!.model as Truck;
              },
              isEnabled: enable,
            ),
          ),
          Expanded(
            child: TWSDatepicker(
              firstDate: _firstDate,
              lastDate: _lastlDate,
              label: 'Trimestral',
              controller: TextEditingController(text: item.maintenanceNavigation?.trimestral.dateOnlyString),
              onChanged: (String text) {
                Truck model = itemState!.model as Truck;
                DateTime date = DateTime.tryParse(text) ?? DateTime(0);
                itemState!.updateModelRedrawing(
                  model.clone(
                    maintenanceNavigation: model.maintenanceNavigation?.clone(trimestral: date) 
                    ?? Maintenance.a().clone(trimestral: date),
                  ),
                );
                model = itemState!.model as Truck;
              },
              isEnabled: enable,
            ),
          ),
        ]),
      ]),
    );
  }
}
