
import 'package:csm_client/csm_client.dart';
import 'package:csm_view/csm_view.dart' hide JObject;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tws_administration_view/data/services/sources.dart';
import 'package:tws_administration_view/data/storages/session_storage.dart';
import 'package:tws_administration_view/view/articles/sections/sections_article.dart';
import 'package:tws_administration_view/view/frames/whisper/whisper_frame.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/records_stack/tws_article_creator_stack_item.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/records_stack/tws_article_creator_stack_item_property.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_agent.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_creation_item_state.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_creator.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_creator_feedback.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_field.dart';
import 'package:tws_administration_view/view/widgets/tws_confirmation_dialog.dart';
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

part '../adapters/sections_whisper_options_adapter.dart';
part 'forms/section_stack_item.dart';
part 'forms/dialogs.dart';

class SectionsCreateWhisper  extends CSMPageBase{
  const SectionsCreateWhisper({super.key});

  Future<List<TWSArticleCreatorFeedback>> _onCreateSections(List<Section> records, BuildContext context) async {
    final String token = _sessionStorage.getTokenStrict();
    List<TWSArticleCreatorFeedback> feedback = <TWSArticleCreatorFeedback>[];

    // --> Create trailers.
    if(records.isNotEmpty){
      MainResolver<SetBatchOut<Section>> resolver = await Sources.foundationSource.sections.create(records, token);
      resolver.resolve(
        decoder: (JObject json) => SetBatchOut<Section>.des(json, Section.des),
        onConnectionFailure: () {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _conectionDialog(context,"Sections");
        },
        onException: (Object exception, StackTrace trace) {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _exceptionDialog(context, "Sections");
        },
        onFailure: (FailureFrame failure, int status) {},
        onSuccess: (SuccessFrame<SetBatchOut<Section>> success) {
          if (success.estela.failed) {
            feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
            _failureDialog(context, success.estela.failures.first.system, "Sections", success.estela.failures);
          } 
        },
      );
    }
    return feedback;
  }

  @override 
  Widget compose(BuildContext ctx, Size window){
    final TWSArticleCreatorAgent<Section> creatorAgent = TWSArticleCreatorAgent<Section>();
    return WhisperFrame(
      title: 'Create sections',
      trigger: creatorAgent.create,
      child: TWSArticleCreator<Section>(
        agent: creatorAgent,
        factory: Section.a,
        afterClose: () => tableAgent.refresh(), 
        modelValidator: (Section model) {
          List<CSMSetValidationResult> evaluation = model.evaluate();
          if(model.locationNavigation == null) evaluation.add(const CSMSetValidationResult("LocationNavigation", "Location not selected", "emptyField()"));
          return evaluation.isEmpty;
        },
        onCreate: (List<Section> records) async {
          return _onCreateSections(records, ctx);
        },
        itemDesigner: (Section actualModel, bool selected, bool valid) {
          return _SectionStackItem(actualModel: actualModel, selected: selected, valid: valid );
        },
        formDesigner: (TWSArticleCreatorItemState<Section>? itemState) {  
          final bool formDisabled = !(itemState == null);
          final ScrollController scrollController = ScrollController();
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CSMSpacingColumn(
                spacing: 10,
                children: <Widget>[
                  TWSInputText(
                    width: double.maxFinite,
                    maxLength: 32,
                    label: 'Name',
                    isStrictLength: false,
                    controller: TextEditingController(text: itemState?.model.name),
                    isEnabled: formDisabled,
                    onChanged: (String text) {
                      Section model = itemState!.model;
                      itemState.updateModelRedrawing(
                        model.clone(
                          name: text,
                        ),
                      );
                    },
                  ),
                  TWSAutoCompleteField<Location>(
                    width: double.maxFinite,
                    label: 'Location',
                    isOptional: true,
                    isEnabled: formDisabled,
                    initialValue: itemState?.model.locationNavigation,
                    adapter: const _LocationsViewAdapter(),
                    displayValue:(Location? item) => item?.name ?? "Not valid data",
                    onChanged: (Location? item) {
                      Section model = itemState!.model;
                      itemState.updateModelRedrawing(
                        model.clone(
                          yard: item?.id ?? 0,
                          locationNavigation: item
                        ),
                      );
                    },
                  ),
                  CSMSpacingRow(
                    spacing: 10,
                    children: <Widget>[
                      Expanded(
                        child: TWSInputText(
                          label: 'Capacity',
                          isStrictLength: false,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: itemState?.model.capacity.toString()),
                          isEnabled: formDisabled,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          onChanged: (String text) {
                            Section model = itemState!.model;
                            itemState.updateModelRedrawing(
                              model.clone(
                                capacity: int.tryParse(text),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: TWSInputText(
                          width: double.maxFinite,
                          label: 'Ocupancy',
                          isStrictLength: false,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: itemState?.model.ocupancy.toString()),
                          isEnabled: formDisabled,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          onChanged: (String text) {
                            Section model = itemState!.model;
                            itemState.updateModelRedrawing(
                              model.clone(
                                ocupancy: int.tryParse(text),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}