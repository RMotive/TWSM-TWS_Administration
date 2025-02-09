import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';
import 'package:tws_administration_view/core/theme/structs/section_theme_struct.dart';

/// TWS Business component.
///
/// Defined to handle section separator along pages sections.
/// Theme Struct:
///   - required[pageColorStruct]
///   - optional[twsSectionStruct]
class TWSSection extends StatelessWidget {
  /// Indicates the display title to show in the section.
  final String title;

  /// The content to be rendered in the section.
  final Widget content;

  /// The padding that the border decorator will use
  final EdgeInsets padding;

  final bool isOptional;
  /// Renders a page section.
  ///
  /// Theme Struct:
  ///   - required[pageColorStruct]
  ///   - optional[twsSectionStruct]
  const TWSSection({
    super.key,
    this.isOptional = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 20,
    ),
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final TWSAThemeBase theme = getTheme();
    final CSMColorThemeOptions pageStruct = theme.page;
    final SectionThemeStruct? sectionStruct = theme.twsSectionStruct;
    final Color borderColor = isOptional ? pageStruct.fore.withValues(alpha: .5) : sectionStruct?.borderColor ?? pageStruct.highlight;
    return Padding(
      padding: padding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(
              width: 2, 
              color: borderColor,
              strokeAlign: BorderSide.strokeAlignCenter
            ),
          ),
        ),
        child: SizedBox(
          width: double.maxFinite,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Transform.translate(
                  offset: const Offset(0, -35),
                  child: ColoredBox(
                    color: pageStruct.main,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        title,
                        style: sectionStruct?.titleStyle ??
                        TextStyle(
                          color: pageStruct.fore,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
