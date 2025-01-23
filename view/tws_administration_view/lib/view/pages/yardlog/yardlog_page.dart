import 'dart:convert';
import 'dart:typed_data';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:csm_client/csm_client.dart' hide JObject;
import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/router/twsa_routes.dart';
import 'package:tws_administration_view/data/services/sources.dart';
import 'package:tws_administration_view/data/storages/session_storage.dart';
import 'package:tws_administration_view/view/frames/article/action_ribbon_options.dart';
import 'package:tws_administration_view/view/pages/yardlog/yardlog_frame.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_agent.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_field_options.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_field.dart';
import 'package:tws_administration_view/view/widgets/tws_button_flat.dart';
import 'package:tws_administration_view/view/widgets/tws_confirmation_dialog.dart';
import 'package:tws_administration_view/view/widgets/tws_datepicker_field.dart';
import 'package:tws_administration_view/view/widgets/tws_image_viewer.dart';
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_administration_view/view/widgets/tws_photo_taker/tws_photo_taker.dart';
import 'package:tws_administration_view/view/widgets/tws_property_viewer.dart';
import 'package:tws_administration_view/view/widgets/tws_section.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';


part 'options/yards_whisper_options_adapter.dart';

String _getDriverName(YardLog item){
  String? name;
  String? fatherlastname;
  String? motherlastname;
  if(item.driverNavigation?.employeeNavigation?.identificationNavigation != null){
    name = item.driverNavigation?.employeeNavigation?.identificationNavigation?.name;
    fatherlastname = item.driverNavigation?.employeeNavigation?.identificationNavigation?.fatherlastname;
    motherlastname = item.driverNavigation?.employeeNavigation?.identificationNavigation?.motherlastname;
  }else if(item.driverExternalNavigation?.identificationNavigation != null){
    name = item.driverExternalNavigation?.identificationNavigation?.name;
    fatherlastname = item.driverExternalNavigation?.identificationNavigation?.fatherlastname;
    motherlastname = item.driverExternalNavigation?.identificationNavigation?.motherlastname;
  }else {
    return " --- ";
  }
  return "$name $fatherlastname $motherlastname";
}

class YardlogPage extends CSMPageBase {
  
  static final TWSArticleTableAgent tableAgent = TWSArticleTableAgent();
  final CSMRouteOptions currentRoute;

  const YardlogPage({
    super.key,
    required this.currentRoute,
  });
  @override
  Widget compose(BuildContext ctx, Size window) {
    _TableAdapter adapter = const _TableAdapter();
    return YardlogFrame(
      currentRoute: TWSARoutes.yardlogPage,
      actionsOptions: ActionRibbonOptions(
        refresher: tableAgent.refresh,
      ),
      article: TWSArticleTable<YardLog>(
        viewerTitle: "Registro",
        removable: false,
        adapter: const _TableAdapter(),
        agent: tableAgent,
        fields: <TWSArticleTableFieldOptions<YardLog>>[
          TWSArticleTableFieldOptions<YardLog>(
            'ID',
            (YardLog item, int index, BuildContext ctx) => item.id.toString(),
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Tipo de registro',
            (YardLog item, int index, BuildContext ctx) => item.entry? 'Entrada' : 'Salida',
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Fecha',
            (YardLog item, int index, BuildContext ctx) => item.timestamp.toIso8601String(),
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Tipo de carga',
            (YardLog item, int index, BuildContext ctx) => item.loadTypeNavigation!.name,
          ),
           TWSArticleTableFieldOptions<YardLog>(
            'Licencia del conductor',
            (YardLog item, int index, BuildContext ctx) => item.driverNavigation != null? item.driverNavigation!.driverCommonNavigation!.license
            : item.driverExternalNavigation != null? item.driverExternalNavigation!.driverCommonNavigation!.license : "Licencia no encontrada."
          ),
           TWSArticleTableFieldOptions<YardLog>(
            'Nombre del conductor',
            (YardLog item, int index, BuildContext ctx) => _getDriverName(item)
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Numero de camión',
            (YardLog item, int index, BuildContext ctx) {
              return  item.truckNavigation != null? item.truckNavigation!.truckCommonNavigation!.economic
              : item.truckExternalNavigation != null? item.truckExternalNavigation!.truckCommonNavigation!.economic
              : 'Placa no econtrada.';
            },  
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Placa del camión',
            (YardLog item, int index, BuildContext ctx) {
              return adapter.getTruckPlates(item);
            },  
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Numero de remolque',
            (YardLog item, int index, BuildContext ctx) {
              return  item.trailerNavigation != null? item.trailerNavigation!.trailerCommonNavigation!.economic
              : item.trailerExternalNavigation != null? item.trailerExternalNavigation!.trailerCommonNavigation!.economic
              : 'Numero de remolque no encontrado.';
            },  
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Placa del remolque',
            (YardLog item, int index, BuildContext ctx) {
              
              return adapter.getTrailerPlates(item);
            },  
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Numero de sello',
            (YardLog item, int index, BuildContext ctx) => item.seal ?? '---',
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Numero de sello #2',
            (YardLog item, int index, BuildContext ctx) => item.sealAlt ?? '---',
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Desde/Hacia',
            (YardLog item, int index, BuildContext ctx) => item.fromTo,
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Daño',
            (YardLog item, int index, BuildContext ctx) => item.damage? "Dañado": "Ninugno",
          ),
          TWSArticleTableFieldOptions<YardLog>(
            'Sección',
            (YardLog item, int index, BuildContext ctx) => item.sectionNavigation != null? "${item.sectionNavigation?.locationNavigation?.name} - ${item.sectionNavigation?.name}" : "---",
          ),
        ],
        page: 1,
        size: 25,
        sizes: const <int>[25, 50, 75, 100],
      ),
    );
  }
}
