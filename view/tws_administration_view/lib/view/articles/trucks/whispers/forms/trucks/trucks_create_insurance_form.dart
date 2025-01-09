part of '../../trucks_create_whisper.dart';

class _TruckCreateInsurance extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;
  const _TruckCreateInsurance({
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final Truck item = itemState!.model as Truck;
    return TWSSection(
      isOptional: true,
      padding: const EdgeInsets.symmetric(vertical: 10),
      title: "Insurance (optional)", 
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
                  label: 'Policy',
                  isStrictLength: true,
                  controller: TextEditingController(text: item.insuranceNavigation?.policy),
                  onChanged: (String text) {
                    Truck model = itemState!.model as Truck;
                    itemState!.updateModelRedrawing(
                      model.clone(
                        insuranceNavigation: model.insuranceNavigation?.clone(policy: text) 
                        ?? Insurance.a().clone(policy: text)
                      ),
                    );
                  },
                  isEnabled: enable,
                ),
              ),
              Expanded(
                child: TWSAutoCompleteField<String>(
                  initialValue: item.insuranceNavigation?.country,
                  isOptional: true,
                  label: 'Country',
                  isEnabled: enable,
                  localList: _countryOptions,
                  displayValue:(String? item) => item ?? "Not valid",
                  onChanged: (String? value) {
                    Truck model = itemState!.model as Truck;
                    itemState!.updateModelRedrawing(
                      model.clone(
                        insuranceNavigation: item.insuranceNavigation?.clone(country: value ?? "") 
                        ?? Insurance.a().clone(country: value)
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          TWSDatepicker(
            width: double.maxFinite,
            firstDate: _firstDate,
            lastDate: _lastlDate,
            label: 'Expiration',
            controller: TextEditingController(text: item.insuranceNavigation?.expiration.dateOnlyString),
            onChanged: (String text) {
              Truck model = itemState!.model as Truck;
              DateTime date = DateTime.tryParse(text) ?? DateTime(0);
              itemState!.updateModelRedrawing(
                model.clone(
                  insuranceNavigation: model.insuranceNavigation?.clone(expiration: date)
                  ?? Insurance.a().clone(expiration: date)
                ),
              );
            },
            isEnabled: enable,
          ),
        ],
      ),
    );
  }
}