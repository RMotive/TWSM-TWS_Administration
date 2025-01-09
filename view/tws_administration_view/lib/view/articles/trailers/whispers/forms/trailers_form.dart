part of '../trailers_create_whisper.dart';

class _TrailerForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool formDisabled;
  final TextStyle style;
  const _TrailerForm({
    required this.style,
    this.itemState,
    this.formDisabled = true,
  });
  @override
  Widget build(BuildContext context) {
    // Truck item = itemState!.model as Truck;
    return CSMSpacingColumn(
      mainSize: MainAxisSize.min,
      spacing: 12,
      crossAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _TrailerCreateMainForm(
          itemState: itemState,
          enable: formDisabled,
        ),
        _TrailersCreatePlatesSection(
          style: style,
          itemState: itemState,
          enable: formDisabled,
        ),
        _TrailerCreateType(
          itemState: itemState,
          enable: formDisabled,
        ),
        _TrailersCreateManufacturer(
          itemState: itemState,
          enable: formDisabled,
          style: style,
        ),
        _TrailersCreateSituation(
          itemState: itemState,
          enable: formDisabled,
          style: style,
        ),
        _TrailersCreateMaintenance(
          itemState: itemState,
          enable: formDisabled,
        ),
        _TrailersCreateSCT(
          itemState: itemState,
          enable: formDisabled,
        )
      ],
    );
  }
}
