import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/view/components/tws_article_creation/records_stack/tws_article_creator_stack_item.dart';
import 'package:tws_administration_view/view/components/tws_article_creation/records_stack/tws_article_creator_stack_item_property.dart';
import 'package:tws_administration_view/view/components/tws_article_creation/tws_article_creation_item_state.dart';
import 'package:tws_administration_view/view/components/tws_article_creation/tws_article_creator.dart';
import 'package:tws_administration_view/view/components/tws_input_text.dart';
import 'package:tws_administration_view/view/frames/whisper/whisper_frame.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

final class ContactsCreateWhisper extends CSMPageBase {
  const ContactsCreateWhisper({super.key});

  @override
  Widget compose(BuildContext ctx, Size window) {
    return WhisperFrame(
      title: 'Create Contact',
      child: TWSArticleCreator<Contact>(
        factory: () => Contact.a(),
        itemDesigner: (Contact actualModel, bool selected, bool valid) {
          return TWSArticleCreationStackItem(
            properties: <TwsArticleCreationStackItemProperty>[
              TwsArticleCreationStackItemProperty(
                label: 'Name',
                minWidth: 100,
                value: actualModel.name,
              ),
              TwsArticleCreationStackItemProperty(
                label: 'Last Name',
                minWidth: 100,
                value: actualModel.lastName,
              ),
              TwsArticleCreationStackItemProperty(
                label: 'E-Mail',
                minWidth: 100,
                value: actualModel.email,
              ),
              TwsArticleCreationStackItemProperty(
                label: 'Phone',
                minWidth: 100,
                value: actualModel.phone,
              ),
            ],
            selected: selected,
          );
        },
        formDesigner: (TWSArticleCreatorItemState<Contact>? itemState) {
          final bool formDisabled = !(itemState == null);

          return CSMSpacingColumn(
            spacing: 12,
            includeStart: true,
            children: <Widget>[
              // --> Name property Input
              TWSInputText(
                label: 'Name',
                isStrictLength: true,
                controller: TextEditingController(text: itemState?.model.name),
                onChanged: (String text) {
                  Contact model = itemState!.model;
                  itemState.updateModelRedrawing(
                    model.clone(
                      name: text,
                    ),
                  );
                },
                maxLength: 5,
                isEnabled: formDisabled,
              ),
              // --> Last Name Property Input
              TWSInputText(
                label: 'Last Name',
                isStrictLength: true,
                maxLength: 5,
                isEnabled: formDisabled,
                controller: TextEditingController(text: itemState?.model.lastName),
                onChanged: (String text) {
                  Contact model = itemState!.model;
                  itemState.updateModelRedrawing(
                    model.clone(
                      lastName: text,
                    ),
                  );
                },
              ),
              // --> E-Mail Property Input
              TWSInputText(
                label: 'E-Mail',
                isStrictLength: true,
                maxLength: 5,
                isEnabled: formDisabled,
                controller: TextEditingController(text: itemState?.model.email),
                onChanged: (String text) {
                  Contact model = itemState!.model;
                  itemState.updateModelRedrawing(
                    model.clone(
                      email: text,
                    ),
                  );
                },
              ),
              // --> Phone Property Input
              TWSInputText(
                label: 'Phone',
                maxLength: 5,
                isEnabled: formDisabled,
                controller: TextEditingController(text: itemState?.model.phone),
                onChanged: (String text) {
                  Contact model = itemState!.model;
                  itemState.updateModelRedrawing(
                    model.clone(
                      phone: text,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
