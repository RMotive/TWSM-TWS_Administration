import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';

class TWSDisplayFlat extends StatelessWidget {
  final String display;
  final double? height;
  final double? width;
  final double? verticalPadding;
  final double? maxHeight;
  final Color? color;
  final Color? foreColor;

  const TWSDisplayFlat({
    super.key,
    this.width,
    this.height,
    this.maxHeight,
    this.verticalPadding,
    this.color,
    this.foreColor,
    required this.display,
  });

  @override
  Widget build(BuildContext context) {
    CSMColorThemeOptions errorStruct = getTheme<TWSAThemeBase>().primaryCriticalControl;
    Color baseColor = color ?? errorStruct.highlight;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: baseColor.withOpacity(.3),
          border: Border.fromBorderSide(
            BorderSide(
              color: baseColor,
              width: 2,
            ),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? (height != null ? 0 : 8),
              horizontal: 8,
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Text(
                  display,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foreColor ?? errorStruct.fore,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
