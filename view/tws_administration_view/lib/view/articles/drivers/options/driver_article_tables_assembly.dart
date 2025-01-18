part of '../drivers_article.dart';


class _DriverArticleTablesAssembly extends StatefulWidget {
  // Main agent for the Article.
  final TWSArticleTableAgent agent;
  // Article State class.
  final _DriversArticleState state;

  const _DriverArticleTablesAssembly({
    required this.agent,
    required this.state,
  });

  @override
  State<_DriverArticleTablesAssembly> createState() => _DriverArticleTablesAssemblyState();
}

class _DriverArticleTablesAssemblyState extends State<_DriverArticleTablesAssembly> {
  // Table adapters declaration.
  late _TableAdapter adapter;
  late _ExternalTableAdapter externalAdapter;

  // Show the truck table based on index value.
  late int index;
  // Stores  [Driver] table as the default table and a sizedbox widget as placeholder to build
  // [DriverExtenal] table ONLY when is required, and preserve the state.
  List<Widget> indexedWidgets = <Widget>[];
  // Flag for [DriverExtenal] table firts build.
  bool hasLoaded = false;

  @override
  void initState() {
    super.initState();
    adapter = _TableAdapter(widget.state);
    externalAdapter = _ExternalTableAdapter(widget.state);
    index = 0;
    indexedWidgets = <Widget>[
      _DriversTable(
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
                label: "Drivers",
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
                label: "External Drivers",
                disabled: index == 1,
                onTap: () {
                  setState(
                    () {
                      if (!hasLoaded) {
                        indexedWidgets[1] = _DriversExternalTable(
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