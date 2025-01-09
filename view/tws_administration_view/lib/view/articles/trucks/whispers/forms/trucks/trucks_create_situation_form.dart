part of '../../trucks_create_whisper.dart';

class _TruckCreateSituation extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;
  final TextStyle style;
  const _TruckCreateSituation({
    required this.style,
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final Truck item = itemState!.model as Truck;
    return TWSSection(
      isOptional: true,
      padding: const EdgeInsets.symmetric(vertical: 10),
      title: "Situation (optional)",
      content: TWSAutoCompleteField<Situation>(
        width: double.maxFinite,
        adapter: const _SituationsViewAdapter(),
        initialValue: item.truckCommonNavigation?.situationNavigation,
        isEnabled: true,
        isOptional: true,
        displayValue: (Situation? item) => item?.name ?? "Not valid data",
        label: 'Situation',
        onChanged: (Situation? value) {
          Truck model = itemState!.model as Truck;
          itemState?.updateModelRedrawing(
            model.clone(
              truckCommonNavigation: model.truckCommonNavigation?.clone(
                situationNavigation: value,
                situation: value?.id ?? 0,
              ) ??
              TruckCommon.a().clone(
                situationNavigation: value,
                situation: value?.id,
              ),
            ),
          );
        },
      ),
    );
  }
}
