part of '../trucks_article.dart';

/// [_TruckArticleTablesAssembly] Component that manage the behavior for the [Truck] & [TruckExternal] tables,
/// allow switching between the two tables selections.
class _TruckArticleTablesAssembly extends StatefulWidget {
  // Main agent for the Article.
  final TWSArticleTableAgent agent;
  // Article State class.
  final _TrucksArticleState state;

  const _TruckArticleTablesAssembly({
    required this.agent,
    required this.state,  
  });

  @override
  State<_TruckArticleTablesAssembly> createState() =>
      _TruckArticleTablesAssemblyState();
}

class _TruckArticleTablesAssemblyState extends State<_TruckArticleTablesAssembly> {
  // Table adapters declaration.
  late _TableAdapter adapter;
  late _ExternalTableAdapter externalAdapter;

  // Show the truck table based on index value.
  late int index;
  // Stores  [Truck] table as the default table and a sizedbox widget as placeholder to build
  // [TruckExternal] table ONLY when is required, and preserve the state.
  List<Widget> indexedWidgets = <Widget>[];
  // Flag for [TruckExternal] table firts build.
  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();
    adapter = _TableAdapter(widget.state);
    externalAdapter = _ExternalTableAdapter(widget.state);
    index = 0;
    indexedWidgets = <Widget>[
      _TruckTable(
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
                label: "Trucks",
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
                label: "External Trucks",
                disabled: index == 1,
                onTap: () {
                  setState(
                    () {
                      if (!hasLoaded) {
                        indexedWidgets[1] = _TruckExternalTable(
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
