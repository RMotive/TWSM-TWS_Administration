import 'package:csm_client/csm_client.dart';
import 'package:csm_view/csm_view.dart' hide JObject; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:tws_administration_view/view/widgets/tws_cascade_section.dart';
import 'package:tws_administration_view/view/widgets/tws_confirmation_dialog.dart';
import 'package:tws_administration_view/view/widgets/tws_display_flat.dart';
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_administration_view/view/widgets/tws_property_viewer.dart';
import 'package:tws_administration_view/view/widgets/tws_section.dart';
import 'package:tws_administration_view/view/widgets/tws_section_divider.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

part 'adapters/location_table_adapter.dart';
part 'adapters/locations_article_state.dart'; 

final TWSArticleTableAgent tableAgent = TWSArticleTableAgent();
final _LocationssArticleState _pageState = _LocationssArticleState(tableAgent);

class LocationsArticle extends CSMPageBase {
  const LocationsArticle({super.key});

  @override
  Widget compose(BuildContext ctx, Size window) {
    return BusinessFrame(
      currentRoute: TWSARoutes.locationsArticle,
      actionsOptions: ActionRibbonOptions(
        refresher: tableAgent.refresh,
        maintenanceGroupConfig: MaintenanceGroupOptions(
          onCreate: () => CSMRouter.i.drive(TWSARoutes.locationsCreateWhisper),
        ),
      ),
      article: CSMDynamicWidget<_LocationssArticleState>(
        state: _pageState,
        designer: (BuildContext ctx, _LocationssArticleState state) {
          return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8.0, left: 8.0, right: 8.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                  minWidth: 200,
                ),
                child: TWSInputText(
                  label: 'Search by name',
                  deBounce: 600.miliseconds,
                  onChanged:(String text) => state.filterName(text),
                ),
              ),
            ),
            Expanded(
              child: TWSArticleTable<Location>(
                editable: true,
                removable: false,
                adapter: _TableAdapter(state),
                agent: tableAgent,
                fields: <TWSArticleTableFieldOptions<Location>>[
                  TWSArticleTableFieldOptions<Location>(
                    'Name',
                    (Location item, int index, BuildContext ctx) {
                      return item.name;
                    },
                  ),
                  TWSArticleTableFieldOptions<Location>(
                    'Country',
                    (Location item, int index, BuildContext ctx) {
                    return item.addressNavigation?.country ?? "---";
                    },
                  ),
                  TWSArticleTableFieldOptions<Location>(
                    'City',
                    (Location item, int index, BuildContext ctx) {
                    return item.addressNavigation?.city ?? "---";
                    },
                  ),
                  TWSArticleTableFieldOptions<Location>(
                    'Street',
                    (Location item, int index, BuildContext ctx) {
                    return item.addressNavigation?.street ?? "---";
                    },
                  ),
                  TWSArticleTableFieldOptions<Location>(
                    'Colonia',
                    (Location item, int index, BuildContext ctx) {
                    return item.addressNavigation?.colonia ?? "---";
                    },
                  ),
                ],
                page: 1,
                size: 25,
                sizes: const <int>[25, 50, 75, 100],
              ),
            ),
          ],
        );
      }),
    );
  }
}