part of 'tws_autocomplete_field.dart';

class _TWSAutocompleteList<T> extends StatelessWidget {
  final ScrollController controller;
  final List<T> list;
  final CSMColorThemeOptions theme;
  final String Function(T?) displayLabel;
  final String Function(T?)? suffixLabel;
  final void Function(String label, T? item) onTap;
  final Color hoverTextColor;

  const _TWSAutocompleteList({
    required this.controller,
    required this.list,
    required this.displayLabel,
    required this.theme,
    required this.onTap,
    required this.hoverTextColor,
    this.suffixLabel,
  });

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      shrinkWrap: true,
      itemExtent: 35,
      controller: controller,
      itemCount: list.length,
      itemBuilder: (_, int index) {
        final T? currentItem = list[index];
        final String label = displayLabel(currentItem);
        // Build the individual option component.
        return TWSListTile(
          label:'$label ${suffixLabel != null? suffixLabel!(currentItem) : ""}',
          onHoverColor: theme.main,
          onHoverTextColor: theme.foreAlt!,
          textColor: theme.foreAlt!,
          onTap: () => onTap(label, currentItem)
        ); 
      }
    );
  }
}