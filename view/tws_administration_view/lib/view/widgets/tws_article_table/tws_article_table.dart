import 'dart:async';

import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/constants/twsa_colors.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_agent.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_field_options.dart';
import 'package:tws_administration_view/view/widgets/tws_display_flat.dart';
import 'package:tws_administration_view/view/widgets/tws_frame_decoration.dart';
import 'package:tws_administration_view/view/widgets/tws_paging_selector.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

part 'tws_article_table_details/tws_article_table_details.dart';
part 'tws_article_table_details/tws_article_table_details_action.dart';
part 'tws_article_table_details/tws_article_table_details_state.dart';
part 'tws_article_table_details/tws_article_table_editor.dart';
part 'tws_article_table_error.dart';
part 'tws_article_table_header/tws_article_table_header.dart';
part 'tws_article_table_loading.dart';

class TWSArticleTable<TArticle extends CSMEncodeInterface> extends StatefulWidget {
  final List<TWSArticleTableFieldOptions<TArticle>> fields;
  final TWSArticleTableAdapter<TArticle> adapter;
  final TWSArticleTableAgent? agent;
  final String viewerTitle;
  final bool editable;
  final bool removable;
  final int page;
  final int size;
  final List<int> sizes;

  const TWSArticleTable({
    super.key,
    this.editable = true,
    this.removable = true,
    this.viewerTitle = "Record",
    this.page = 1,
    this.agent,
    required this.size,
    required this.sizes,
    required this.fields,
    required this.adapter,
  });

  @override
  State<TWSArticleTable<TArticle>> createState() => _TWSArticleTableState<TArticle>();
}

class _TWSArticleTableState<TArticle extends CSMEncodeInterface> extends State<TWSArticleTable<TArticle>> with SingleTickerProviderStateMixin {
  static const double _kPagingHeight = 50;
  static const double _kMinFieldWidth = 200;
  static const double _kDetailsWidth = 400;

  late Future<SetViewOut<TArticle>> Function() consume;
  late AnimationController detailsAnimationController;
  late ScrollController horizontalController;
  final CSMConsumerAgent agent = CSMConsumerAgent();

  late final TWSArticleTableAdapter<TArticle> adapter;

  // --> State resources
  late (int index, TArticle item)? selected;
  late List<TArticle> records;
  late int items;
  late int page;
  late int pages;
  late int size;
  late final List<int> sizes;

  void updatePaging(int page, int size) {
    setState(() {
      this.page = page;
      this.size = size;
      this.consume = () => adapter.consume(page, size, <SetViewOrderOptions>[]);
    });
    agent.refresh();
  }

  @override
  void initState() {
    selected = null;
    page = widget.page;
    horizontalController = ScrollController();
    sizes = widget.sizes;
    pages = page;
    size = widget.size;
    items = 0;
    adapter = widget.adapter;
    records = <TArticle>[];
    consume = () => adapter.consume(page, size, <SetViewOrderOptions>[]);
    detailsAnimationController = AnimationController(vsync: this, duration: 200.miliseconds);
    widget.agent?.addListener(agent.refresh);
    super.initState();
  }

  @override
  void dispose() {
    widget.agent?.removeListener(agent.refresh);
    detailsAnimationController.dispose();
    horizontalController.dispose();
    super.dispose();
  }

  void _updatePagingChanges(SetViewOut<TArticle> data) {
    if (items != data.count || pages != data.pages || records != data.records) {
      WidgetsBinding.instance.addPostFrameCallback(
        (Duration timeStamp) {
          setState(() {
            records = data.records;
            items = data.count;
            pages = data.pages;
          });
        },
      );
    }
  }

  void _selectRecord(int index, TArticle set) {
    setState(() {
      if (selected?.$1 == index) {
        selected = null;
        detailsAnimationController.reverse();
      } else {
        selected = (index, set);
        detailsAnimationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constrains) {
        BoxConstraints pageBounds = constrains;
        if (!constrains.hasBoundedHeight) {
          pageBounds = constrains.tighten(
            height: constrains.minHeight,
          );
        }
    
        final Size viewSize = pageBounds.biggest;
        final bool detailsFullDisplay = viewSize.width <= (_kDetailsWidth * 2);
        final Animation<double> detailsDisplayAnimation = Tween<double>(
          begin: 0,
          end: detailsFullDisplay ? viewSize.width : _kDetailsWidth,
        ).animate(detailsAnimationController);
    
        return SizedBox(
          width: viewSize.width,
          child: AnimatedBuilder(
            animation: detailsDisplayAnimation,
            builder: (_, __) {
              final double animationComputationValue = viewSize.width - detailsDisplayAnimation.value;
              final double cellWidth = animationComputationValue / widget.fields.length;
    
              return Stack(
                children: <Widget>[
                  // --> Table
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: detailsFullDisplay ? viewSize.width : animationComputationValue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // --> Table content
                        Expanded(
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              border: Border.fromBorderSide(
                                BorderSide(
                                  width: 2,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                            child: Scrollbar(
                              controller: horizontalController,
                              interactive: true,
                              child: SingleChildScrollView(
                                controller: horizontalController,
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // --> Table header draw
                                    _TWSArticleTableHeader<TArticle>(
                                      fields: widget.fields,
                                      minFieldWidth: _kMinFieldWidth,
                                      fieldWidth: cellWidth,
                                    ),
                                    // --> Table items
                                    Expanded(
                                      child: CSMConsumer<SetViewOut<TArticle>>(
                                        consume: consume,
                                        agent: agent,
                                        emptyCheck: (SetViewOut<TArticle> data) => data.records.isEmpty,
                                        loadingBuilder: (_) => _TWSArticleTableLoading(viewSize: viewSize),
                                        errorBuilder: (_, __, ___) => _TWSArticleTableError(
                                          viewSize: viewSize,
                                        ),
                                        successBuilder: (_, SetViewOut<TArticle> data) {
                                          _updatePagingChanges(data);
    
                                          return SizedBox(
                                            height: pageBounds.maxHeight - 100,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: List<Widget>.generate(
                                                  data.length,
                                                  (int index) {
                                                    return CSMPointerHandler(
                                                      cursor: SystemMouseCursors.click,
                                                      onClick: () => _selectRecord(index, data.records[index]),
                                                      child: DecoratedBox(
                                                        decoration: BoxDecoration(
                                                          color: selected?.$1 == index ? Colors.blueGrey : Colors.transparent,
                                                        ),
                                                        child: Row(
                                                          children: <Widget>[
                                                            for (TWSArticleTableFieldOptions<TArticle> field in widget.fields)
                                                              ConstrainedBox(
                                                                constraints: const BoxConstraints(
                                                                  minWidth: _kMinFieldWidth,
                                                                ),
                                                                child: SizedBox(
                                                                  width: cellWidth,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      vertical: 6,
                                                                      horizontal: 8,
                                                                    ),
                                                                    child: Builder(builder: (BuildContext context) {
                                                                      final String cellValue = field.factory(data.records[index], index, context);
                                                                      final Widget textWidget = Text(
                                                                        cellValue,
                                                                        maxLines: 2,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      );
    
                                                                      if (!field.tip) {
                                                                        return textWidget;
                                                                      }
                                                                      return Tooltip(
                                                                        message: cellValue,
                                                                        child: textWidget,
                                                                      );
                                                                    }),
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // --> Paging selection
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: animationComputationValue,
                          ),
                          child: SizedBox(
                            height: _kPagingHeight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: TWSPagingSelector(
                                pages: pages,
                                size: size,
                                items: records.length,
                                sizes: sizes,
                                total: items,
                                onChange: updatePaging,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // --> Item detail
                  if (selected != null)
                    Positioned(
                      left: animationComputationValue,
                      width: detailsFullDisplay ? viewSize.width : _kDetailsWidth,
                      height: viewSize.height,
                      child: _TWSArticleTableDetails<TArticle>(
                        viewerTitle: widget.viewerTitle,
                        editable: widget.editable,
                        removable: widget.removable,
                        adapter: widget.adapter,
                        record: selected!.$2,
                        closeAction: () {
                          if (selected != null) {
                            _selectRecord(selected!.$1, selected!.$2);
                          }
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
