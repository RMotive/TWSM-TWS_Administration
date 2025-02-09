
import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/extension/datetime.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';


/// [TWSDatepicker] Custom component for TWS Environment.
/// This component shows a datepicker dialog to select a date.
class TWSDatepicker extends StatefulWidget {
  /// First selectable date.
  final DateTime firstDate;
  /// Last selectable date.
  final DateTime lastDate;
  /// Text field width.
  final double width;
  /// Text field heigth.
  final double height;
  /// Text field title.
  final String? label;
  /// Text field hintext.
  final String? hintText;
  /// Optional focus node.
  final FocusNode? focusNode;
  /// Default pre-selected Date.
  final DateTime? initialDate;
  /// Optional Text controller.
  final TextEditingController? controller;
  /// Defines if the user can interact with the widget.
  final bool isEnabled;
  ///
  final bool enablePrefix;
  /// Callback that return the selected options in the datepicker dialog.
  final void Function(String text)? onChanged;
  /// Validator for the text input.
  final String? Function(String? text)? validator;

  const TWSDatepicker({super.key,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.width = 200,
    this.height = 40,
    this.label,
    this.hintText,
    this.focusNode,
      this.enablePrefix = true,
    this.isEnabled = true,
    this.controller,
    this.onChanged,
    this.validator
  });
  
  @override
  State<TWSDatepicker> createState() => _TWSDatepickerState();
}

class _TWSDatepickerState extends State<TWSDatepicker> {
  String? _error;
  
  final double borderWidth = 2;
  late TextEditingController ctrl;
  late final FocusNode fNode;
  late final TWSAThemeBase theme;
  late final CSMColorThemeOptions colorStruct;
  late final CSMColorThemeOptions disabledColorStruct;
  late final CSMColorThemeOptions errorColorStruct;

  @override
  void initState() {
    super.initState();
    ctrl = widget.controller ??
        TextEditingController(
          text: widget.initialDate?.dateOnlyString,
        );
    fNode = widget.focusNode ?? FocusNode();
    theme = getTheme(
      updateEfect: themeUpdateListener,
    );
    initializeThemes();
    ctrl.addListener(() => setState(() {}));
  }
  
  @override
  void didUpdateWidget(covariant TWSDatepicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      ctrl = widget.controller ?? TextEditingController();
    }

    ctrl.addListener(() => setState(() {}));
  }
  void initializeThemes() {
    colorStruct = theme.primaryControlColor;
    disabledColorStruct = theme.primaryDisabledControl;
    errorColorStruct = theme.primaryCriticalControl;
  }

  void themeUpdateListener() {
    setState(() {
      theme = getTheme();
      initializeThemes();
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
        child: Material(
          color: Colors.transparent,
          child: TextFormField(
            autofocus: true,
            readOnly: true,
            validator: widget.validator,
            controller: ctrl,
            focusNode: fNode,
            enabled: widget.isEnabled,
            cursorOpacityAnimates: true,
            cursorWidth: 3,
            cursorColor: colorStruct.foreAlt,
            style: TextStyle(
              color: colorStruct.foreAlt?.withValues(alpha: .7),
            ),
            onTap: () => _showDatePicker(),
            decoration: InputDecoration(
              isDense: true,
              errorText: _error,
              errorMaxLines: 1,
              suffixIcon: const Icon(
                Icons.calendar_month,
              ),
              suffixIconColor: colorStruct.main,
              prefixIcon: (widget.enablePrefix && ctrl.text.isNotEmpty)
                  ? IconButton(
                      tooltip: "Delete selection",
                      icon: Icon(
                        Icons.cancel,
                        color: colorStruct.highlight,
                        size: 20,
                      ),
                      onPressed: () {
                        // update the widget state to hide the delete button.
                        setState(() {
                          ctrl.text = '';
                          widget.onChanged?.call('');
                        });
                      },
                    )
                  : null,
              labelText: widget.label,
              hintText: widget.hintText,
              labelStyle: TextStyle(
                color: colorStruct.foreAlt,
              ),
              errorStyle: TextStyle(
                color: errorColorStruct.fore,
              ),
              hintStyle: TextStyle(
                color: colorStruct.fore,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colorStruct.highlight.withValues(alpha: .6),
                  width: borderWidth,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: disabledColorStruct.highlight,
                  width: borderWidth,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: errorColorStruct.highlight.withValues(alpha: .7),
                  width: borderWidth,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: errorColorStruct.highlight,
                  width: borderWidth,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorStruct.highlight, width: borderWidth),
              ),
            ),
          ),
      )
    );
  }
  /// [_showDatePicker] Method that build the showpicker dialog.
  Future<void> _showDatePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: widget.initialDate,
      firstDate: widget.firstDate, 
      lastDate: widget.lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              surface: colorStruct.main, //Background color
              primary: colorStruct.fore, // header background color
              onPrimary: colorStruct.foreAlt ?? Colors.white, // header text color
              onSurface: colorStruct.foreAlt ?? Colors.white // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colorStruct.foreAlt ?? Colors.white // button text color
              )
            )
          ),
          child: child!
        );
      }
    );
    if(date != null) {
      String? errorBuilt = widget.validator?.call(date.dateOnlyString);
      if (errorBuilt == null) {
        setState(() {
          _error = null;
          ctrl.text = date.dateOnlyString;
          if (widget.onChanged != null) widget.onChanged!(ctrl.text);
        });
      } else {
        setState(() {
          _error = errorBuilt;
        });
      }
    }
  }
}