part of 'tws_autocomplete_field.dart';

class _TWSAutocompleteFuture<T> extends StatelessWidget {
  final Future<List<SetViewOut<dynamic>>> Function() consume;
  final ScrollController controller;
  final double tileHeigth;
  final CSMColorThemeOptions theme;
  final String Function(T?) displayLabel;
  final String Function(T?)? suffixLabel;
  final void Function(String label, T? item) onTap;
  final List<T> Function(List<SetViewOut<dynamic>> data) onFetch;
  final Color loadingColor;
  final Color hoverTextColor;
  final CSMConsumerAgent agent;

  const _TWSAutocompleteFuture({
    required this.consume,
    required this.controller,
    required this.displayLabel,
    required this.theme,
    required this.onTap,
    required this.loadingColor,
    required this.hoverTextColor,
    required this.onFetch,
    required this.tileHeigth,
    required this.agent,
    this.suffixLabel
  });


  List<T> getSets(List<SetViewOut<dynamic>> rawData){
    List<T> data = <T>[];
    for (SetViewOut<dynamic> view in rawData) {
      data = <T>[...data, ...view.sets];
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return CSMConsumer<List<SetViewOut<dynamic>>>(
      consume: consume,
      agent: agent,
      emptyCheck: (List<SetViewOut<dynamic>> data) {
        onFetch(data); 
        int cont = 0;
        for(SetViewOut<dynamic> view in data){
          cont += view.sets.length;
        }
        return cont == 0? true: false;
      },
      loadingBuilder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: CircularProgressIndicator(
            backgroundColor: TWSAColors.darkGrey,
            color: loadingColor,
            strokeWidth: 4,
          ),
        );
      },
      errorBuilder: (BuildContext ctx, Object? error, List<SetViewOut<dynamic>>? data) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: TWSDisplayFlat(
            display: error == null? 'No hay resultados' : "Problema al cargar",
          ),
        );
      },
      successBuilder: (BuildContext ctx, List<SetViewOut<dynamic>> rawData) {
        onFetch(rawData); 
        return Scrollbar(
          trackVisibility: true,
          thumbVisibility: true,
          controller: controller,
          child: _TWSAutocompleteList<T>(
            controller: controller,
            list: getSets(rawData) ,
            suffixLabel: suffixLabel,
            displayLabel: displayLabel,
            theme: theme,
            hoverTextColor: hoverTextColor,
            onTap: onTap,
          )
        );
      }
    );
  }
}