part of '../../trailers_create_whisper.dart';

class _TrailersCreateSituation extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;
  final TextStyle style;
  const _TrailersCreateSituation({
    required this.style,
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final Trailer item = itemState!.model as Trailer;
    return TWSSection(
      isOptional: true,
      padding: const EdgeInsets.symmetric(vertical: 10),
      title: "Situation (optional)",
      content: TWSAutoCompleteField<Situation>(
        width: double.maxFinite,
        adapter: const _SituationsViewAdapter(),
        initialValue: item.trailerCommonNavigation?.situationNavigation,
        isEnabled: true,
        isOptional: true,
        displayValue: (Situation? item) => item?.name ?? "Not valid data",
        label: 'Situation',
        onChanged: (Situation? value) {
          Trailer model = itemState!.model as Trailer;
          itemState?.updateModelRedrawing(
            model.clone(
              trailerCommonNavigation: model.trailerCommonNavigation?.clone(
                situationNavigation: value,
                situation: value?.id ?? 0,
              ) ??
              TrailerCommon.a().clone(
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
