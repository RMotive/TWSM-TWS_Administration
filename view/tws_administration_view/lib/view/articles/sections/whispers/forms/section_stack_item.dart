part of '../sections_create_whisper.dart';


class _SectionStackItem extends StatelessWidget {
  final Section actualModel;
  final bool selected;
  final bool valid;
  const _SectionStackItem({
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
          label: 'Location',
          minWidth: 150,
          value: actualModel.locationNavigation?.name ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Capacity',
          minWidth: 150,
          value: actualModel.capacity.toString(),
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Ocupancy',
          minWidth: 150,
          value: actualModel.ocupancy.toString(),
        ),
      ],
    );
  }
}
