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
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_administration_view/view/widgets/tws_property_viewer.dart';
import 'package:tws_administration_view/view/widgets/tws_section.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';
part 'options/driver_article_tables_assembly.dart';
part 'options/adapters/drivers_table_adapter.dart';
part 'options/adapters/drivers_externals_table_adapter.dart';
part 'options/drivers_table.dart';
part 'options/drivers_externals_table.dart';
part 'options/drivers_article_state.dart';

final TWSArticleTableAgent tableAgent = TWSArticleTableAgent();
final _DriversArticleState _pageState = _DriversArticleState(tableAgent);

class DriversArticle extends CSMPageBase {
  const DriversArticle({super.key});

  @override
  Widget compose(BuildContext ctx, Size window) {
    return BusinessFrame(
      currentRoute: TWSARoutes.driversArticle,
      actionsOptions: ActionRibbonOptions(
        refresher: tableAgent.refresh,
        maintenanceGroupConfig: MaintenanceGroupOptions(
          onCreate: () => CSMRouter.i.drive(TWSARoutes.driversCreateWhisper),
        ),
      ),
      article: CSMDynamicWidget<_DriversArticleState>(
        state: _pageState,
        designer: (BuildContext ctx, _DriversArticleState state) {
          double optionsWidth = 250;
          return Column(
          children: <Widget>[
            SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8.0, left: 8.0, right: 8.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    TWSInputText(
                      label: 'Search by license',
                      deBounce: 600.miliseconds,
                      width: optionsWidth,
                      onChanged:(String text) => state.filterLicense(text),
                    ),
                      TWSInputText(
                      label: 'Search by name',
                      deBounce: 600.miliseconds,
                      width: optionsWidth,
                      onChanged:(String text) => state.filterName(text),
                    ),
                    TWSInputText(
                      label: 'Search by father lastname',
                      deBounce: 600.miliseconds,
                      width: optionsWidth,
                      onChanged:(String text) => state.filterFather(text),
                    ),
                    TWSInputText(
                      label: 'Search by mother lastname',
                      deBounce: 600.miliseconds,
                      width: optionsWidth,
                      onChanged:(String text) => state.filterMother(text),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _DriverArticleTablesAssembly(
                agent: tableAgent,
                state: state,
              ),
            ),
          ],
        );
      }),
    );
  }
}