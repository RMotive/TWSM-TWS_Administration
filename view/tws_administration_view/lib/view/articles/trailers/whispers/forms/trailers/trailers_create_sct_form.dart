part of '../../trailers_create_whisper.dart';

class _TrailersCreateSCT extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;
  const _TrailersCreateSCT({
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    final Trailer item = itemState!.model as Trailer;
    return TWSSection(
      isOptional: true,
      padding: const EdgeInsets.symmetric(vertical: 10),
      title: "SCT (optional)",
      content: CSMSpacingColumn(spacing: 10, children: <Widget>[
        CSMSpacingRow(spacing: 10, children: <Widget>[
          Expanded(
            child: TWSInputText(
              label: 'Type',
              maxLength: 6,
              isStrictLength: true,
              controller: TextEditingController(text: item.sctNavigation?.type),
              onChanged: (String text) {
                Trailer model = itemState!.model as Trailer;
                itemState!.updateModelRedrawing(
                  model.clone(
                    sctNavigation: model.sctNavigation?.clone(type: text) ??
                      SCT.a().clone(type: text),
                  ),
                );
              },
              isEnabled: enable,
            ),
          ),
          Expanded(
            child: TWSInputText(
              label: 'Configuration',
              maxLength: 10,
              controller: TextEditingController(
                  text: item.sctNavigation?.configuration),
              onChanged: (String text) {
                Trailer model = itemState!.model as Trailer;
                itemState!.updateModelRedrawing(
                  model.clone(
                    sctNavigation: model.sctNavigation?.clone(configuration: text) 
                    ?? SCT.a().clone(configuration: text)
                  ),
                );
              },
              isEnabled: enable,
            ),
          ),
        ]),
        TWSInputText(
          width: double.maxFinite,
          label: 'Number',
          maxLength: 25,
          isStrictLength: true,
          controller: TextEditingController(text: item.sctNavigation?.number,),
          onChanged: (String text) {
            Trailer model = itemState!.model as Trailer;
            itemState!.updateModelRedrawing(
              model.clone(
                sctNavigation: model.sctNavigation?.clone(number: text) ??
                SCT.a().clone(number: text),
              ),
            );
          },
          isEnabled: enable,
        ),
      ]),
    );
  }
}
