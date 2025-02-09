import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/router/twsa_routes.dart';
import 'package:tws_administration_view/data/services/sources.dart';
import 'package:tws_administration_view/data/storages/session_storage.dart';
import 'package:tws_administration_view/view/frames/article/action_ribbon_options.dart';
import 'package:tws_administration_view/view/pages/security/security_frame.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_agent.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_field_options.dart';
import 'package:tws_administration_view/view/widgets/tws_confirmation_dialog.dart';
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_administration_view/view/widgets/tws_property_viewer.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

part 'options/solutions_article_table_adapter.dart';



class SolutionsArticle extends CSMPageBase {
  
  static final TWSArticleTableAgent tableAgent = TWSArticleTableAgent();
  const SolutionsArticle({super.key});

  @override
  Widget compose(BuildContext ctx, Size window) {

    return SecurityFrame(
      currentRoute: TWSARoutes.solutionsArticle,
      actionsOptions: ActionRibbonOptions(
        refresher: tableAgent.refresh,
      ),
      article: TWSArticleTable<Solution>(
        adapter: const _TableAdapter(),
        removable: false,
        agent: tableAgent,
        fields: <TWSArticleTableFieldOptions<Solution>>[
          TWSArticleTableFieldOptions<Solution>(
            'Name',
            (Solution item, int index, BuildContext ctx) => item.name,
          ),
          TWSArticleTableFieldOptions<Solution>(
            'Sign',
            (Solution item, int index, BuildContext ctx) => item.sign,
          ),
          TWSArticleTableFieldOptions<Solution>(
            'Description',
            (Solution item, int index, BuildContext ctx) => item.description ?? '---',
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
