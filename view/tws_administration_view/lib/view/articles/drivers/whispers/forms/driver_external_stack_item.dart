part of '../drivers_create_whisper.dart';

class _DriverExternalStackItem extends StatelessWidget {
  final DriverExternal actualModel;
  final bool selected;
  final bool valid;
  const _DriverExternalStackItem({
    required this.actualModel,
    required this.selected,
    required this.valid,
  });

  @override
  Widget build(BuildContext context) {
    return TWSArticleCreationStackItem(
      selected: selected,
      valid: valid,
      properties: <TwsArticleCreationStackItemProperty>[
        TwsArticleCreationStackItemProperty(
          label: 'License',
          minWidth: 150,
          value: actualModel.driverCommonNavigation?.license ?? '---',
        ),
       TwsArticleCreationStackItemProperty(
          label: 'Name',
          minWidth: 150,
          value: actualModel.identificationNavigation?.name ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Father lastname',
          minWidth: 150,
          value: actualModel.identificationNavigation?.fatherlastname ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Mother lastname',
          minWidth: 150,
          value: actualModel.identificationNavigation?.motherlastname ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Birthday',
          minWidth: 150,
          value: actualModel.identificationNavigation?.birthday?.dateOnlyString ?? '---',
        ),
      ],
    );
  }
}