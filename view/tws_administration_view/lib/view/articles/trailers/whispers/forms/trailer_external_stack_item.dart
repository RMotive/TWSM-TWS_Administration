part of '../trailers_create_whisper.dart';

class _TrailerExternalStackItem extends StatelessWidget {
  final TrailerExternal actualModel;
  final bool selected;
  final bool valid;
  const _TrailerExternalStackItem({
    required this.actualModel,
    required this.selected,
    required this.valid,
  });

  String displayInsurance(Insurance? insurance) {
    String data = "---";
    if (insurance != null && (insurance.country.isNotEmpty && insurance.policy.isNotEmpty)) {
      data = insurance.policy;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return TWSArticleCreationStackItem(
      selected: selected,
      valid: valid,
      properties: <TwsArticleCreationStackItemProperty>[
        TwsArticleCreationStackItemProperty(
          label: 'Economic',
          minWidth: 150,
          value: actualModel.trailerCommonNavigation?.economic ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Type',
          minWidth: 150,
          value: actualModel.trailerCommonNavigation?.trailerTypeNavigation !=
                  null
              ? "${actualModel.trailerCommonNavigation?.trailerTypeNavigation?.trailerClassNavigation?.name} - ${actualModel.trailerCommonNavigation?.trailerTypeNavigation?.size}"
              : "---",
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Carrier',
          minWidth: 150,
          value: actualModel.carrier,
        ),
        TwsArticleCreationStackItemProperty(
          label: 'MX Plate',
          minWidth: 150,
          value: actualModel.mxPlate ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'USA Plate',
          minWidth: 150,
          value: actualModel.usaPlate ?? '---',
        ),
      ],
    );
  }
}
