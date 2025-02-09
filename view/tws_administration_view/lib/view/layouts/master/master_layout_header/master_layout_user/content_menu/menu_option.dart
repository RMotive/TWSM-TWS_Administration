part of '../../../master_layout.dart';

class _MenuOption extends StatelessWidget {
  /// [options] Component option configuration.
  final _Options options;
  /// [color] Component Color.
  final Color color;
  /// [onTap] Tap event function.
  final void Function() onTap;

  const _MenuOption(
    {required this.options, required this.color, required this.onTap}
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: double.maxFinite,
        height: 40,
        child: FloatingActionButton(
            highlightElevation: 0,
            elevation: 0,
            hoverElevation: 0,
            splashColor: const Color.fromARGB(0, 229, 216, 216),
            hoverColor: color.withValues(alpha: .1),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onPressed: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Button content
                Row(
                  children: <Widget>[
                    Icon(
                      options.icon,
                      color: color,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        options.title,
                        style: TextStyle(color: color),
                      ),
                    ),
                  ],
                ),

                // Suffix Icon
                Visibility(
                  visible: options.suffix,
                  child: Icon(
                    Icons.chevron_right_outlined,
                    color: color,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
