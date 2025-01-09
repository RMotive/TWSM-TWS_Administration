part of '../locations_create_whisper.dart';

class _LocationsCreateWaypointForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Location>? itemState;
  final bool enable;

  const _LocationsCreateWaypointForm({
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return TWSSection(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      title: "Waypoint", 
      content: CSMSpacingColumn(
        spacing: 10,
        children: <Widget>[
          CSMSpacingRow(
            crossAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: <Widget>[
              Expanded(
                child: TWSInputText(
                  label: "Longitude",
                  hint: "Add longitude cord.",
                  isEnabled: enable,
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  showErrorColor: !(itemState?.model.waypointNavigation?.longitude.toString() ?? "0.0").evaluateAsDecimal(),
                  controller: TextEditingController(text: itemState?.model.waypointNavigation?.longitude.toString()),
                  formatter: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                  ],
                  onChanged: (String text) {
                    Location model = itemState!.model;
                    itemState?.updateModelRedrawing(
                      model.clone(
                        waypointNavigation: model.waypointNavigation?.clone(
                          longitude: double.tryParse(text) ?? 0.0,
                        ) ?? Waypoint.a().clone(
                          longitude: double.tryParse(text) ?? 0.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: TWSInputText(
                  label: "Latitude",
                  hint: "Add latitude cord.",
                  isEnabled: enable,
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  showErrorColor: !(itemState?.model.waypointNavigation?.latitude.toString() ?? "0.0").evaluateAsDecimal(),
                  controller: TextEditingController(text: itemState?.model.waypointNavigation?.latitude.toString()),
                  formatter: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                  ],
                  onChanged: (String text) {
                    Location model = itemState!.model;
                    itemState?.updateModelRedrawing(
                      model.clone(
                        waypointNavigation: itemState?.model.waypointNavigation?.clone(
                          latitude: double.tryParse(text) ?? 0.0,
                        ) ?? Waypoint.a().clone(
                          latitude: double.tryParse(text) ?? 0.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          CSMSpacingRow(
            spacing: 10,
            children: <Widget>[
              Expanded(
                child: TWSInputText(
                  label: "Altitude",
                  hint: "Add Altitude cord.",
                  suffixLabel: " opt.",
                  isEnabled: enable,
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  showErrorColor: itemState?.model.waypointNavigation?.altitude != null? !(itemState?.model.waypointNavigation?.altitude.toString() ?? "").evaluateAsDecimal() : false,
                  controller: TextEditingController(text: itemState?.model.waypointNavigation?.altitude.toString()),
                  formatter: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                  ],
                  onChanged: (String text) {
                    Location model = itemState!.model;
                    itemState?.updateModelRedrawing(
                      model.clone(
                        waypointNavigation: itemState?.model.waypointNavigation?.clone(
                          altitude: double.tryParse(text) ?? 0.0,
                        ) ?? Waypoint.a().clone(
                          altitude: double.tryParse(text) ?? 0.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
