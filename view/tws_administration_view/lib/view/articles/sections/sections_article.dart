import 'package:csm_client/csm_client.dart';
import 'package:csm_view/csm_view.dart' hide JObject; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:tws_administration_view/view/widgets/tws_confirmation_dialog.dart';
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_administration_view/view/widgets/tws_property_viewer.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

part 'adapters/sections_table_adapter.dart';


class SectionsArticle extends CSMPageBase {
  static final TWSArticleTableAgent tableAgent = TWSArticleTableAgent();
  const SectionsArticle({super.key});

  @override
  Widget compose(BuildContext ctx, Size window) {
    return BusinessFrame(
      currentRoute: TWSARoutes.sectionsArticle,
      actionsOptions: ActionRibbonOptions(
        refresher: tableAgent.refresh,
        maintenanceGroupConfig: MaintenanceGroupOptions(
          onCreate: () => CSMRouter.i.drive(TWSARoutes.sectionsCreateWhisper),
        ),
      ),
      article: TWSArticleTable<Section>(
        editable: true,
        removable: false,
        adapter: const _TableAdapter(),
        agent: tableAgent,
        fields: <TWSArticleTableFieldOptions<Section>>[
          TWSArticleTableFieldOptions<Section>(
            'Name',
            (Section item, int index, BuildContext ctx) {
             return item.name;
            },
          ),
          TWSArticleTableFieldOptions<Section>(
            'Location',
            (Section item, int index, BuildContext ctx) {
             return item.locationNavigation?.name ?? '---';
            },
          ),
          TWSArticleTableFieldOptions<Section>(
            'Capacity',
            (Section item, int index, BuildContext ctx) {
             return item.capacity.toString();
            },
          ),
          TWSArticleTableFieldOptions<Section>(
            'Ocupancy',
            (Section item, int index, BuildContext ctx) {
             return item.ocupancy.toString();
            },
          ),
        ],
        page: 1,
        size: 25,
        sizes: const <int>[25, 50, 75, 100],
      )
    );
  }
}