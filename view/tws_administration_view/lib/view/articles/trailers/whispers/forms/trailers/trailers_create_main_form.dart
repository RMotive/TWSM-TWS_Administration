part of '../../trailers_create_whisper.dart';

class _TrailerCreateMainForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;

  const _TrailerCreateMainForm({
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final Trailer item = itemState!.model as Trailer;
    return CSMSpacingColumn(spacing: 10, children: <Widget>[
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
                Trailer model = itemState!.model as Trailer;
                itemState!.updateModelRedrawing(
                  model.clone(
                    trailerCommonNavigation:
                        model.trailerCommonNavigation?.clone(economic: text) ??
                            TrailerCommon.a().clone(economic: text),
                  ),
                );
              },
              isEnabled: enable,
            ),
          ),
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
                Trailer model = itemState!.model as Trailer;
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
        ],
      ),
    ]);
  }
}
