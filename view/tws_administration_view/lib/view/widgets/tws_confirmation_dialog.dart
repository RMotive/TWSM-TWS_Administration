import 'dart:async';
import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';
import 'package:tws_administration_view/view/widgets/tws_button_flat.dart';


final class TWSConfirmationDialog extends StatefulWidget {
  final String title;
  final Text? statement;
  final bool showCancelButton;
  final String accept;
  final VoidCallback? onClose;
  final FutureOr<void> Function()? onAccept;

  const TWSConfirmationDialog({
    super.key,
    this.onClose,
    this.onAccept,
    this.statement,
    this.showCancelButton = true,
    this.title = 'Confirmation',
    this.accept = 'Accept',
  });

  @override
  State<TWSConfirmationDialog> createState() => _TWSConfirmationDialogState();
}

class _TWSConfirmationDialogState extends State<TWSConfirmationDialog> {
  bool loading = false;

  @override
  void initState() {
    ServicesBinding.instance.keyboard.addHandler(_keyHandler);

    super.initState();
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_keyHandler);
    super.dispose();
  }

  bool _keyHandler(KeyEvent event) {
    final String key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      if (key == 'Escape' && !loading) {
        widget.onClose?.call();
        Navigator.of(context).pop();
      }
    }
    return false;
  }

  void _close(BuildContext ctx) {
    Navigator.of(ctx).pop();
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    final TWSAThemeBase theme = getTheme<TWSAThemeBase>();

    final CSMColorThemeOptions pageTheme = theme.page;
    final CSMColorThemeOptions dangerTheme = theme.primaryCriticalControl;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (loading) {
          return;
        }

        widget.onClose?.call();
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
              maxHeight: 450,
            ),
            child: GestureDetector(
              onTap: () {},
              child: ColoredBox(
                color: pageTheme.main,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // --> Dialog header
                    ColoredBox(
                      color: pageTheme.highlight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              widget.title,
                              style: TextStyle(
                                color: pageTheme.fore,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: loading ? null : () => _close(context),
                                    icon: Icon(
                                      Icons.close,
                                      color: dangerTheme.highlight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // --> Dialog body
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: pageTheme.fore,
                            ),
                            child: widget.statement ??
                                const Text(
                                  'Are you sure you want to continue?',
                                ),
                          ),
                        ),
                      ),
                    ),
                    // --> Dialog footer
                    ColoredBox(
                      color: pageTheme.highlight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        child: CSMSpacingRow(
                          spacing: 12,
                          mainAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TWSButtonFlat(
                              label: widget.accept,
                              waiting: loading,
                              onTap: () async {
                                if (widget.onAccept == null) {
                                  return;
                                }

                                setState(() {
                                  loading = true;
                                });
                                await widget.onAccept!();
                                setState(() {
                                  loading = false;
                                });
                              },
                            ),
                            Visibility(
                              visible: widget.showCancelButton,
                              child: TWSButtonFlat(
                                label: 'Cancel',
                                disabled: loading,
                                themeOptions: dangerTheme,
                                onTap: () => _close(context),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
