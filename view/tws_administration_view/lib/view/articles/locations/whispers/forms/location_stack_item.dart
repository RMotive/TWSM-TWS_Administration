part of '../locations_create_whisper.dart';


class _LocationStackItem extends StatelessWidget {
  final Location actualModel;
  final bool selected;
  final bool valid;
  const _LocationStackItem({
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
          label: 'Name',
          minWidth: 150,
          value: actualModel.name,
        ),
       TwsArticleCreationStackItemProperty(
          label: 'Country',
          minWidth: 150,
          value: actualModel.addressNavigation?.country ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'State',
          minWidth: 150,
          value: actualModel.addressNavigation?.state ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'City',
          minWidth: 150,
          value: actualModel.addressNavigation?.city ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Street',
          minWidth: 150,
          value: actualModel.addressNavigation?.street ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Alt. Street',
          minWidth: 150,
          value: actualModel.addressNavigation?.altStreet ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'ZIP',
          minWidth: 150,
          value: actualModel.addressNavigation?.zip ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Colonia',
          minWidth: 150,
          value: actualModel.addressNavigation?.colonia ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Longitude',
          minWidth: 150,
          value: actualModel.waypointNavigation?.longitude.toString() ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Latitude',
          minWidth: 150,
          value: actualModel.waypointNavigation?.latitude.toString() ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Altitude',
          minWidth: 150,
          value:actualModel.waypointNavigation?.altitude != null? actualModel.waypointNavigation?.altitude.toString() ?? '---' : "---",
        ),
      ],
    );
  }
}
