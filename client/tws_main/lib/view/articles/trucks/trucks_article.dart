import 'package:csm_foundation_view/csm_foundation_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_service/tws_administration_service.dart';
import 'package:tws_main/core/router/twsa_routes.dart';
import 'package:tws_main/data/services/sources.dart';
import 'package:tws_main/data/storages/session_storage.dart';
import 'package:tws_main/view/frames/article/action_ribbon_options.dart';
import 'package:tws_main/view/frames/article/actions/maintenance_group_options.dart';
import 'package:tws_main/view/frames/business/business_frame.dart';
import 'package:tws_main/view/widgets/tws_article_table/tws_article_table.dart';
import 'package:tws_main/view/widgets/tws_article_table/tws_article_table_data_adapter.dart';
import 'package:tws_main/view/widgets/tws_article_table/tws_article_table_field_options.dart';
part 'options/trucks_article_table_adapter.dart';

class TrucksArticle extends CSMPageBase {
  const TrucksArticle({super.key});

  @override
  Widget compose(BuildContext ctx, Size window) {
    return BusinessFrame(
      currentRoute: TWSARoutes.trucksArticle,
      actionsOptions: ActionRibbonOptions(
        maintenanceGroupConfig: MaintenanceGroupOptions(
          onCreate: () {
            
          },
        ),
      ),
      article: TWSArticleTable<Truck>(
        adapter: const _TableAdapter(),
        fields: <TWSArticleTableFieldOptions<Truck>>[
          TWSArticleTableFieldOptions<Truck>(
            'VIN number',
            (Truck item, int index, BuildContext ctx) => item.vin,
          ),
          TWSArticleTableFieldOptions<Truck>(
            'Manufacturer',
            (Truck item, int index, BuildContext ctx) => item.manufacturer.toString(),
          ),
          TWSArticleTableFieldOptions<Truck>(
            'Motor',
            (Truck item, int index, BuildContext ctx) => item.motor,
            true,
          ),
          TWSArticleTableFieldOptions<Truck>(
            'SCT',
            (Truck item, int index, BuildContext ctx) => item.sct.toString(),
            true,
          ),
          TWSArticleTableFieldOptions<Truck>(
            'Maintenance',
            (Truck item, int index, BuildContext ctx) => item.maintenance.toString() ?? '---',
            true,
          ),
          TWSArticleTableFieldOptions<Truck>(
            'Situation',
            (Truck item, int index, BuildContext ctx) => item.situation.toString(),
            true,
          ),
          TWSArticleTableFieldOptions<Truck>(
            'Insurance',
            (Truck item, int index, BuildContext ctx) => item.insurance.toString(),
            true,
          ),
        ],
        page: 1,
        size: 25,
        sizes: const <int>[25, 50, 75, 100],
      ),
    );
  }
}
