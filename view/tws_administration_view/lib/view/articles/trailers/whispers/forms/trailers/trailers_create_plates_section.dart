part of '../../trailers_create_whisper.dart';


class _TrailersCreatePlatesSection extends StatelessWidget {
  final TWSArticleCreatorItemState<Object>? itemState;
  final bool enable;
  final TextStyle style;
  const _TrailersCreatePlatesSection({
    required this.style,
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return TWSSection(
      title: "Add Plates",
      padding: const EdgeInsets.symmetric(vertical: 20),
      content: TWSIncrementalList<Plate>(
        title: "Plates",
        modelBuilder: Plate.a,
        recordLimit: 2,
        recordList: (itemState!.model as Trailer).plates, 
        onAdd: (Plate plate) {
          Trailer model = itemState!.model as Trailer;
          model.plates.add(plate);
          itemState!.updateModelRedrawing(model);
        },
        onRemove: () {
          Trailer model = itemState!.model as Trailer;
          model.plates.removeLast();
          itemState!.updateModelRedrawing(model);
        },
        recordBuilder:(Plate record, int index) {
          return _TrailerCreatePlateForm(
            index: index,
            plate: record,
            identifierOnChange:(String text) {
              Trailer model = itemState!.model as Trailer;
              model.plates[index].identifier = text;
              itemState!.updateModelRedrawing(model);
            },
            countryOnChange:(String? text) {
              Trailer model = itemState!.model as Trailer;
              model.plates[index].country = text ?? "";
              itemState!.updateModelRedrawing(model);
            }, 
            stateOnChange:(String? text) {
              Trailer model = itemState!.model as Trailer;
              model.plates[index].state = text;
              itemState!.updateModelRedrawing(model);
            }, 
            expirationOnChange:(String text) {
              Trailer model = itemState!.model as Trailer;
              model.plates[index].expiration = DateTime.tryParse(text);
              itemState!.updateModelRedrawing(model);
            },
          );
        },
      ),
    );
  }
}