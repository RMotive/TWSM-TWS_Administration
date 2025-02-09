import 'dart:async';
import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/constants/twsa_colors.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_display_flat.dart';
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_administration_view/view/widgets/tws_list_tile.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

part 'tws_autocomplete_not_found.dart';
part 'tws_autocomeplete_future.dart';
part 'tws_autocomplete_list.dart';
part 'tws_autocomplete_local.dart';

/// [TWSAutoCompleteField] Custom component for TWS enviroment.
/// This component stores a list of posibles options to select for the user.
/// Performs a input filter based on user input text.
/// The Data is fetched throw Future async methods or non-async methods.
/// check properties descriptions. Not set both.
/// T generic must be an Object type for Future-async collections.
class TWSAutoCompleteField<T> extends StatefulWidget {
  /// Field width.
  final double width;

  /// Field height.
  final double? height;

  /// Main title for the field.
  final String? label;

  /// Placeholder Text.
  final String? hint;

  /// Set an initial value. Use ONLY for forms state management.
  /// This value is searched in the adapter data soruce and selected automaticaly (if exist) on each repaint.
  final T? initialValue;

  /// Defines if the user can interact with the widget.
  final bool isEnabled;

  /// Set has non-required field, changing the border color when input is empty.
  final bool isOptional;

  /// Set the text to show when [IsOptional] is true.
  final String? isOptionalLabel;

  /// Optional Focus node to manage
  final FocusNode? focus;

  /// Variable that stores a [TWSFutureAutocompleteAdapter] class to consume the data (Only for async data).
  final TWSAutocompleteAdapter? adapter;

  /// List for process non-async data.
  final List<T>? localList;

  /// Method that returns the value to show from [TList] Object.
  final String Function(T?) displayValue;

  /// Overlay menu height.
  final double menuHeight;

  /// Return the input text and the item property for last suggested item available based on the user input.
  final void Function(T? selection) onChanged;

  /// Optinal validator method for [TWSInputText] internal component.
  final String? Function(String?)? validator;

  /// enable focus events (Autofocus on tap)
  final bool  focusEvents;

  const TWSAutoCompleteField(
      {super.key,
      required this.onChanged,
      required this.displayValue,
      this.focusEvents = false,
      this.adapter,
      this.localList,
      this.isOptionalLabel,
      this.initialValue,
      this.isOptional = false,
      this.focus,
      this.label,
      this.hint,
      this.width = 150,
      this.height,
      this.menuHeight = 200,
      this.validator,
      this.isEnabled = true})
      : assert(localList != null || adapter != null, "At least one data type must be assigned"),
        assert(localList == null || adapter == null, "Only one data type must be assigned (local or future-async)");

  @override
  State<TWSAutoCompleteField<T>> createState() => _TWSAutoCompleteFieldState<T>();
}

class _TWSAutoCompleteFieldState<T> extends State<TWSAutoCompleteField<T>> with SingleTickerProviderStateMixin {
  late final TWSAThemeBase theme;

  /// Consume method declaration in [adapter] property.
  late final Future<List<SetViewOut<dynamic>>> Function()? consume;

  /// Internal scroll controller for overlay scrolling.
  late final ScrollController scrollController;

  /// Color pallet for the component.
  late final CSMColorThemeOptions primaryColorTheme;
  late final CSMColorThemeOptions pageColorTheme;

  /// focus Node declaration.
  late final FocusNode focus;

  /// Link to attach ovelay component UI to the to the TWSInputText.
  final LayerLink link = LayerLink();

  /// Overlay controller.
  late OverlayPortalController overlayController;

  /// Main controller for the TWSInputText.
  late TextEditingController ctrl;

  /// Stores the current selected item.
  T? selectedOption;

  /// Stores the last selected value. If the last input is invalid, then stores null.
  T? previousSelection;

  /// Flag for componet first build.
  bool firstbuild = true;

  /// Original Options list given in builder parameter.
  List<T> rawOptionsList = <T>[];

  /// UI list. List to display on overlay menu, that shows the suggestions options.
  List<T> suggestionsList = <T>[];

  /// Flag to indicate if the overlay component is hovered.
  bool isOvelayHovered = false;

  /// Defines if the overlay is showing.
  bool show = false;

  /// Methoth that verify if the [TWSTextField] component has a valid input selection.
  bool _verifySelection() {
    if (selectedOption != null) return true;
    return false;
  }

  /// Method to filter the Original options list based on user input.
  void _search(String input) {
    selectedOption = null;
    String query = input.toLowerCase();
    List<T> exactCoincidense = <T>[];
    if (query.isNotEmpty) {
      //Do a search for the method input variable for parcial results.
      suggestionsList = rawOptionsList.where((T set) {
        return widget.displayValue(set).toLowerCase().contains(query);
      }).toList();

      //Do a search for exact coincidenses.
      exactCoincidense = suggestionsList.where((T set){
        return widget.displayValue(set).toLowerCase() == query;
      }).toList();
      
      if(suggestionsList.isNotEmpty && exactCoincidense.isNotEmpty) {
        selectedOption = exactCoincidense.first;
        if(!firstbuild) ctrl.text = input;
      }
      
    } else {
      // if the input is empty, then the default suggestions list is the original options list.
      suggestionsList = rawOptionsList;
    }
    if (!firstbuild) {
      setState(() {
        if(previousSelection != selectedOption) widget.onChanged(selectedOption);
      });
    }
    previousSelection = selectedOption;
  }

  @override
  void initState() {
    theme = getTheme(
      updateEfect: themeUpdateListener,
    );
    scrollController = ScrollController();
    primaryColorTheme = theme.primaryControlColor;
    pageColorTheme = theme.page;
    ctrl = TextEditingController(text: widget.initialValue != null ? widget.displayValue(widget.initialValue) : null);
    focus = widget.focus ?? FocusNode();
    overlayController = OverlayPortalController();
    if (widget.adapter != null) {
      consume = () => widget.adapter!.consume(1, 99999, <SetViewOrderOptions>[]);
    } else {
      rawOptionsList = widget.localList!;
    }
    focus.addListener(focusManager);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TWSAutoCompleteField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.localList != null && oldWidget.localList != null){
      if(widget.localList != oldWidget.localList){
        rawOptionsList = widget.localList!;
        ctrl.text = "";
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => setSelection());
  }

  @override
  void dispose() {
    focus.dispose();
    scrollController.dispose();
    ctrl.dispose();
    super.dispose();
  }

  /// Method that manage and assign the [initialValue] property.
  void setSelection() {
    if (widget.initialValue != null) {
      String value = widget.displayValue(widget.initialValue);
      _search(value);
    } else {
      if (previousSelection != null) {
        ctrl.text = "";
        _search("");
      }
    }
  }

  void themeUpdateListener() {
    setState(() {
      theme = getTheme();
      primaryColorTheme = theme.primaryControlColor;
    });
  }

  /// Method that manage the focus events to show or hide the overlay
  void focusManager() {
    if (focus.hasPrimaryFocus) {
      if (firstbuild) overlayController.show();
      setState(() => show = true);
    } else {
      setState(() => show = false);
    }
  }

  void onTileTap(String label) {
    setState(() {
      _search(label);
      show = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color highContrastColor = primaryColorTheme.hightlightAlt ?? Colors.white;
    const double tileHeigth = 35;
    return SizedBox(
        width: widget.width,
        child: OverlayPortal(
            controller: overlayController,
            child: CompositedTransformTarget(
                link: link,
                child: TWSInputText(
                  autofocus: false,
                  focusEvents: widget.focusEvents,
                  controller: ctrl,
                  isOptional: widget.isOptional,
                  width: widget.width,
                  height: widget.height,
                  suffixLabel: widget.isOptionalLabel,
                  focusNode: focus,
                  label: widget.label,
                  hint: widget.hint,
                  isEnabled: widget.isEnabled,
                  showErrorColor: (selectedOption == null && (!widget.isOptional || ctrl.text.isNotEmpty)) && !firstbuild,
                  onChanged: (String text) => _search(text),
                  suffixIcon: const Icon(
                    Icons.arrow_drop_down,
                    size: 24,
                    color: Colors.white,
                  ),
                  onTap: () {
                    if (!show) setState(() => show = true);
                  },
                  onTapOutside: (_) {
                    if (!isOvelayHovered) setState(() => show = false);
                    if (!show) focus.unfocus();
                  },
                  validator: (String? text) {
                    if (_verifySelection()) return "Not exist an item with this value.";
                    if (widget.validator != null) return widget.validator!(text);
                    return null;
                  },
                ),),
            overlayChildBuilder: (_) {
              // Getting the visual boundries for this component.
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              final Size renderSize = renderBox.size;
              return Positioned(
                  width: renderSize.width,
                  child: CompositedTransformFollower(
                    showWhenUnlinked: false,
                    offset: Offset(0, renderSize.height),
                    link: link,
                    // Overlay pointer handler
                    child: CSMPointerHandler(
                      onHover: (bool hover) => isOvelayHovered = hover,
                      child: Visibility(
                          visible: show,
                          maintainState: true,
                          child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: widget.menuHeight),
                              child: ClipRRect(
                                  child: DecoratedBox(
                                      decoration: const BoxDecoration(
                                          color: TWSAColors.ligthGrey,
                                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                                          border: Border(
                                              right: BorderSide(width: 2, color: TWSAColors.oceanBlue),
                                              left: BorderSide(width: 2, color: TWSAColors.oceanBlue),
                                              bottom: BorderSide(width: 2, color: TWSAColors.oceanBlue),),),
                                      child: widget.adapter != null
                                          ? _TWSAutocompleteFuture<T>(
                                              consume: consume!,
                                              controller: scrollController,
                                              tileHeigth: tileHeigth,
                                              suggestions: suggestionsList,
                                              displayLabel: widget.displayValue,
                                              theme: primaryColorTheme,
                                              loadingColor: highContrastColor,
                                              hoverTextColor: pageColorTheme.fore,
                                              firstBuild: firstbuild,
                                              onTap: (String label) => onTileTap(label),
                                              onFirstBuild: (List<SetViewOut<dynamic>> data) {
                                                //Only do the builder callback once.
                                                //Stores the properties result to avoid unnecesary callbacks on rebuild.
                                                for (SetViewOut<dynamic> view in data) {
                                    rawOptionsList = <T>[...rawOptionsList, ...view.records];
                                                }
                                                _search(ctrl.text);
                                                firstbuild = false;
                                                return suggestionsList;
                                              })
                                          : _TWSAutocompleteLocal<T>(
                                              controller: scrollController,
                                              suggestions: suggestionsList,
                                              displayLabel: widget.displayValue,
                                              theme: primaryColorTheme,
                                              onTap: (String label) => onTileTap(label),
                                              loadingColor: highContrastColor,
                                              hoverTextColor: pageColorTheme.fore,
                                              onFirstBuild: () {
                                                _search(ctrl.text);
                                                firstbuild = false;
                                                return suggestionsList;
                                              },
                                              tileHeigth: tileHeigth,
                                              firstBuild: firstbuild,
                                              rawData: widget.localList!),),),),),
                    ),
                  ),);
            },),);
  }
}
