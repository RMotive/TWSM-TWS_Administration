import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/router/twsa_routes.dart';
import 'package:tws_administration_view/data/services/sources.dart';
import 'package:tws_administration_view/data/storages/session_storage.dart';
import 'package:tws_administration_view/view/frames/article/action_ribbon_options.dart';
import 'package:tws_administration_view/view/pages/human_resources/human_resources_frame.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_agent.dart';
import 'package:tws_administration_view/view/widgets/tws_article_table/tws_article_table_field_options.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

// --> Services
final SessionStorage _sessionStorage = SessionStorage.i;

final class ContactsArticle extends CSMPageBase {
  const ContactsArticle({super.key});

  @override
  Widget compose(BuildContext ctx, Size window) {
    final TWSArticleTableAgent tableAgent = TWSArticleTableAgent();
    
    return HumanResourcesFrame(
      currentRoute: TWSARoutes.contactsArticle,
      actionsOptions: ActionRibbonOptions(
        refresher: tableAgent.refresh,
      ),
      article: TWSArticleTable<Contact>(
        fields: <TWSArticleTableFieldOptions<Contact>>[
          TWSArticleTableFieldOptions<Contact>(
            'Name',
            (Contact item, int index, BuildContext ctx) => item.name,
          ),
          TWSArticleTableFieldOptions<Contact>(
            'Last Name',
            (Contact item, int index, BuildContext ctx) => item.lastName.isEmpty ? '---' : item.lastName,
          ),
          TWSArticleTableFieldOptions<Contact>(
            'Email',
            (Contact item, int index, BuildContext ctx) => item.email,
          ),
        ],
        adapter: const ContactsTableAdapter(),
        agent: tableAgent,
        page: 1,
        size: 25,
        sizes: const <int>[25, 50, 75, 100],
      ),
    );
  }
}

final class ContactsTableAdapter extends TWSArticleTableAdapter<Contact> {
  const ContactsTableAdapter();

  @override
  TWSArticleTableEditor? composeEditor(CSMEncodeInterface set, void Function() closeReinvoke, BuildContext context) => null;

  @override
  Widget composeViewer(CSMEncodeInterface set, BuildContext context) {
    return const SizedBox();
  }

  @override
  Future<SetViewOut<Contact>> consume(int page, int range, List<SetViewOrderOptions> orderings) async {
    final SetViewOptions<Contact> options = SetViewOptions<Contact>(false, range, page, null, orderings, <SetViewFilterNodeInterface<Contact>>[]);
    String auth = _sessionStorage.session!.token;
    MainResolver<SetViewOut<Contact>> resolver = await Sources.foundationSource.contacts.view(options, auth);

    SetViewOut<Contact> view = await resolver.act((Map<String, dynamic> json) => SetViewOut<Contact>.des(json, Contact.des)).catchError(
      (Object x, StackTrace s) {
        const CSMAdvisor('contact-table-adapter').exception('Exception catched at table view consume', Exception(x), s);
        throw x;
      },
    );
    return view;
  }
}
