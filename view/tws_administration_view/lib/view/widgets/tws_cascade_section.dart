import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';
import 'package:tws_administration_view/view/widgets/tws_section.dart';

class TWSCascadeSection extends StatefulWidget {
  final String title;
  final Widget mainControl;
  final Widget content;
  final void Function(bool isShowing)? onPressed;
  final String? tooltip;
  final EdgeInsets padding;
  // Aligment for main controls row.
  final MainAxisAlignment mainAxisAlignment;
  const TWSCascadeSection({
    super.key,
    this.onPressed,
    this.tooltip,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.mainAxisAlignment =  MainAxisAlignment.spaceBetween,
    required this.title,
    required this.mainControl,
    required this.content

  });

  @override
  State<TWSCascadeSection> createState() => _TWSCascadeSectionState();
}

class _TWSCascadeSectionState extends State<TWSCascadeSection> {
  bool show = false;
  late final TWSAThemeBase theme;
  late final CSMColorThemeOptions colorStruct;
  late final CSMColorThemeOptions disabledColorStruct;
  late final CSMColorThemeOptions errorColorStruct;

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

  void showCascade(){
    setState(() {
      show = !show;
    });
  }

  @override
  void initState() {
    super.initState();
    theme = getTheme(
      updateEfect: themeUpdateListener,
    );
    initializeThemes();
  }
  @override
  Widget build(BuildContext context) {
    return TWSSection(
      padding: widget.padding,
      title: widget.title, 
      content: CSMSpacingColumn(
        spacing: 10,
        children: <Widget>[
          CSMSpacingRow(
            spacing: 10,
            mainAlignment: widget.mainAxisAlignment,
            children: <Widget>[
              widget.mainControl,
              IconButton(
                hoverColor: colorStruct.fore,
                isSelected: show,
                selectedIcon: const Icon(Icons.remove),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(colorStruct.hightlightAlt ?? colorStruct.highlight,),
                ),
                padding: EdgeInsets.zero,
                tooltip: widget.tooltip,
                color: Colors.white,
                iconSize: 32,
                onPressed: () {
                  showCascade();
                  if(widget.onPressed != null) widget.onPressed!(show);
                },
                icon: const Icon(Icons.add,),),
            ],
          ),
          Visibility(
            visible: show,
            child: widget.content
          )
        ],
      )
    );
  }
}