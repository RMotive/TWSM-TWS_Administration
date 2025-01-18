import 'package:csm_client/csm_client.dart';
import 'package:csm_view/csm_view.dart' hide JObject;
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/constants/twsa_colors.dart';
import 'package:tws_administration_view/core/constants/twsa_common_displays.dart';
import 'package:tws_administration_view/core/router/twsa_routes.dart';
import 'package:tws_administration_view/data/services/sources.dart';
import 'package:tws_administration_view/data/storages/session_storage.dart';
import 'package:tws_administration_view/view/frames/article/action_ribbon_options.dart';
import 'package:tws_administration_view/view/frames/article/actions/maintenance_group_options.dart';
import 'package:tws_administration_view/view/pages/business/business_frame.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_agent.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_field_options.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_field.dart';
import 'package:tws_administration_view/view/widgets/tws_button_flat.dart';
import 'package:tws_administration_view/view/widgets/tws_cascade_section.dart';
import 'package:tws_administration_view/view/widgets/tws_confirmation_dialog.dart';
import 'package:tws_administration_view/view/widgets/tws_datepicker_field.dart';
import 'package:tws_administration_view/view/widgets/tws_display_flat.dart';
import 'package:tws_administration_view/view/widgets/tws_incremental_list.dart';
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_administration_view/view/widgets/tws_property_viewer.dart';
import 'package:tws_administration_view/view/widgets/tws_section.dart';
import 'package:tws_administration_view/view/widgets/tws_section_divider.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';
part 'options/adapters/trailer_article_table_adapter.dart';
part 'options/adapters/trailer_external_article_table_adapter.dart';
part 'options/trailer_article_tables_assembly.dart';
part 'options/trailer_external_table.dart';
part 'options/trailer_table.dart';
part 'options/trailers_article_state.dart';

final TWSArticleTableAgent tableAgent = TWSArticleTableAgent();
final _TrailersArticleState _pageState = _TrailersArticleState(tableAgent);

class TrailersArticle extends CSMPageBase {
  const TrailersArticle({super.key});

  @override
  Widget compose(BuildContext ctx, Size window) {
    return BusinessFrame(
      currentRoute: TWSARoutes.trailersArticle,
      actionsOptions: ActionRibbonOptions(
        refresher: tableAgent.refresh,
        maintenanceGroupConfig: MaintenanceGroupOptions(
          onCreate: () => CSMRouter.i.drive(TWSARoutes.trailersCreateWhisper),
        ),
      ),
      article: 
      
      CSMDynamicWidget<_TrailersArticleState>(
        state: _pageState,
        designer: (BuildContext ctx, _TrailersArticleState state) {
          return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8.0, left: 8.0, right: 8.0),
                child: TWSInputText(
                  label: 'Search by Economic',
                  deBounce: 600.miliseconds,
                  width: double.maxFinite,
                  onChanged:(String text) => state.filterSearch(text),
                ),
              ),
            ),
            Expanded(
              child: _TrailerArticleTablesAssembly(
                agent: tableAgent,
                state: state,
              ),
            ),
          ],
        );
        },
      ),
      
    );
  }
}
