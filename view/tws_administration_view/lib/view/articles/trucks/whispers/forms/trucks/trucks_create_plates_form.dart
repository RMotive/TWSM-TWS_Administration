part of '../../trucks_create_whisper.dart';

class _TruckCreatePlateForm extends StatelessWidget {
  // Initial plate data.
  final Plate plate;
  // current plate index.
  final int index;
  // Inputs onChange methods.
  final void Function(String) identifierOnChange;
  final void Function(String?) countryOnChange;
  final void Function(String?) stateOnChange;
  final void Function(String) expirationOnChange;

  const _TruckCreatePlateForm({
    required this.plate,
    required this.identifierOnChange,
    required this.countryOnChange,
    required this.stateOnChange,
    required this.expirationOnChange,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return CSMSpacingColumn(
      mainSize: MainAxisSize.min,
      spacing: 10,
      children: <Widget>[
        TWSSectionDivider(color: Colors.white, text: "Plate ${index + 1}"),
        CSMSpacingRow(
          crossAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: <Widget>[
            Expanded(
              child: TWSAutoCompleteField<String>(
                localList: _countryOptions,
                initialValue: plate.country == "" ? null : plate.country,
                displayValue:(String? item) => item ?? "Not valid data",
                label: 'Country',
                onChanged: countryOnChange
              ),
            ),
            Expanded(
              child: TWSAutoCompleteField<String>(
                label: 'State',
                suffixLabel: " opt.",
                isOptional: true,
                localList: const <String>[..._mxStateOptions, ..._usaStateOptions],
                displayValue: (String? query) => query ?? "---" ,
                initialValue: plate.state == "" ? null : plate.state,
                onChanged: stateOnChange,
              ),
            ),
        ]),
        TWSInputText(
          width: double.maxFinite,
          label: 'Identifier',
          isStrictLength: false,
          maxLength: 12,
          controller: TextEditingController(text: plate.identifier),
          onChanged: identifierOnChange,
        ),
        CSMSpacingRow(
          spacing: 10,
          children: <Widget>[
            Expanded(
              child: TWSDatepicker(
                firstDate: _firstDate,
                lastDate: _lastlDate,
                suffixLabel: " opt.",
                label: 'Expiration Date',
                controller: TextEditingController(text: plate.expiration?.dateOnlyString),
                onChanged: expirationOnChange,
              ),
            ),
          ]
        )
      ],
    );
  }
}