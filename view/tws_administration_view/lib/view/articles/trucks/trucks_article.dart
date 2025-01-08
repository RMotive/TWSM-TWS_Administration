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
part 'options/adapters/trucks_article_table_adapter.dart';
part 'options/adapters/truck_external_article_table_adapter.dart';
part 'options/truck_article_tables_assembly.dart';
part 'options/truck_external_table.dart';
part 'options/truck_table.dart';

class TrucksArticle extends CSMPageBase {
  static final TWSArticleTableAgent tableAgent = TWSArticleTableAgent();
  const TrucksArticle({super.key});

  @override
  Widget compose(BuildContext ctx, Size window) {
    return BusinessFrame(
      currentRoute: TWSARoutes.trucksArticle,
      actionsOptions: ActionRibbonOptions(
        refresher: tableAgent.refresh,
        maintenanceGroupConfig: MaintenanceGroupOptions(
          onCreate: () => CSMRouter.i.drive(TWSARoutes.trucksCreateWhisper),
        ),
      ),
      article: _TruckArticleTablesAssembly(
        agent: tableAgent,
      ),
    );
  }
}
