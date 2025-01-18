part of '../trailers_article.dart';

/// [_TrailerArticleTablesAssembly] Component that manage the behavior for the [Trailer] & [TrailerExternal] tables,
/// allow switching between the two tables selections.
class _TrailerArticleTablesAssembly extends StatefulWidget {
  // Main agent for the Article.
  final TWSArticleTableAgent agent;
  // Article State class.
  final _TrailersArticleState state;

  const _TrailerArticleTablesAssembly({
    required this.agent,
    required this.state,
  });

  @override
  State<_TrailerArticleTablesAssembly> createState() =>
      _TrailerArticleTablesAssemblyState();
}

class _TrailerArticleTablesAssemblyState
    extends State<_TrailerArticleTablesAssembly> {
  // Table adapters declaration.
  late _TableAdapter adapter;
  late _ExternalTableAdapter externalAdapter;

  // Show the Trailer table based on index value.
  late int index;
  // Stores  [Trailer] table as the default table and a sizedbox widget as placeholder to build
  // [TrailerExternal] table ONLY when is required, and preserve the state.
  List<Widget> indexedWidgets = <Widget>[];
  // Flag for [TrailerExternal] table firts build.
  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();
    adapter = _TableAdapter(widget.state);
    externalAdapter = _ExternalTableAdapter(widget.state);
    index = 0;
    indexedWidgets = <Widget>[
      _TrailerTable(
        agent: widget.agent,
        adapter: adapter,
      ),
      const SizedBox.shrink() // --> Placeholder widget.
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // ---> Options header.
        Padding(
          padding: const EdgeInsets.all(10),
          child: CSMSpacingRow(spacing: 10, children: <Widget>[
            Expanded(
              child: TWSButtonFlat(
                label: "Trailers",
                disabled: index == 0,
                onTap: () {
                  setState(
                    () {
                      index = 0;
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: TWSButtonFlat(
                label: "External Trailers",
                disabled: index == 1,
                onTap: () {
                  setState(
                    () {
                      if (!hasLoaded) {
                        indexedWidgets[1] = _TrailerExternalTable(
                          agent: widget.agent,
                          adapter: externalAdapter,
                        );
                        hasLoaded = true;
                      }
                      index = 1;
                    },
                  );
                },
              ),
            ),
          ]),
        ),
        // --> Table dynamic content.
        Expanded(
          child: IndexedStack(
            index: index,
            children: indexedWidgets,
          ),
        ),
      ],
    );
  }
}
