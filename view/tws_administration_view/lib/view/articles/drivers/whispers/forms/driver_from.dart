part of '../drivers_create_whisper.dart';

class _DriverForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool formDisabled;
  final TextStyle style;
  const _DriverForm({
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
        _DriversCreateEmployeeForm(
          itemState: itemState,
          enable: formDisabled,
        ),
        _DriversCreateMainForm(
          itemState: itemState,
          enable: formDisabled,
        ),
      ],
    );
  }
}