part of 'tws_autocomplete_field.dart';

class _TWSAutocompleteLocal<T> extends StatelessWidget {
  final ScrollController controller;
  final List<T> suggestions;
  final List<T> rawData;
  final double tileHeigth;
  final CSMColorThemeOptions theme;
  final String Function(T?) displayLabel;
  final void Function(String label, T? item) onTap;
  final List<T> Function() onFirstBuild;
  final Color loadingColor;
  final Color hoverTextColor;
  final bool firstBuild;

  const _TWSAutocompleteLocal({
    required this.controller,
    required this.suggestions,
    required this.displayLabel,
    required this.theme,
    required this.onTap,
    required this.loadingColor,
    required this.hoverTextColor,
    required this.onFirstBuild,
    required this.tileHeigth,
    required this.firstBuild,
    required this.rawData
  });

  @override
  Widget build(BuildContext context) {
    return suggestions.isNotEmpty || firstBuild? Scrollbar(
      trackVisibility: true,
      thumbVisibility: true,
      controller: controller,
      child: _TWSAutocompleteList<T>(
        controller: controller,
        list: firstBuild? onFirstBuild() : suggestions,
        displayLabel: displayLabel,
        theme: theme,
        hoverTextColor: hoverTextColor,
        onTap: onTap,
      )
    ) 
    :_TWSAutocompleteNotfound(
      height: tileHeigth, 
      color: loadingColor
    );
  }
}