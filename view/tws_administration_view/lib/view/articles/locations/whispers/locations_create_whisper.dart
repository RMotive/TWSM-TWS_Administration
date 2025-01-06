
import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tws_administration_view/core/constants/twsa_common_displays.dart';
import 'package:tws_administration_view/data/services/sources.dart';
import 'package:tws_administration_view/data/storages/session_storage.dart';
import 'package:tws_administration_view/view/articles/locations/locations_article.dart';
import 'package:tws_administration_view/view/frames/whisper/whisper_frame.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/records_stack/tws_article_creator_stack_item.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/records_stack/tws_article_creator_stack_item_property.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_agent.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_creation_item_state.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_creator.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_creator_feedback.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_field.dart';
import 'package:tws_administration_view/view/widgets/tws_cascade_section.dart';
import 'package:tws_administration_view/view/widgets/tws_confirmation_dialog.dart';
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_administration_view/view/widgets/tws_section.dart';
import 'package:tws_administration_view/view/widgets/tws_section_divider.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

part '../options/adapters/locations_whisper_options_adapter.dart';
part 'forms/location_stack_item.dart';
part 'forms/locations_create_address_form.dart';
part 'forms/locations_create_waypoint_form.dart';
part 'forms/dialogs.dart';

const List<String> _countryOptions = TWSAMessages.kCountryList;
const List<String> _usaStateOptions = TWSAMessages.kUStateCodes;
const List<String> _mxStateOptions = TWSAMessages.kMXStateCodes;

class LocationsCreateWhisper  extends CSMPageBase{
  const LocationsCreateWhisper({super.key});

  Future<List<TWSArticleCreatorFeedback>> _onCreateTrailers(List<Location> records, BuildContext context) async {
    final String token = _sessionStorage.getTokenStrict();
    List<TWSArticleCreatorFeedback> feedback = <TWSArticleCreatorFeedback>[];

    // --> Create trailers.
    if(records.isNotEmpty){
      MainResolver<SetBatchOut<Location>> resolver = await Sources.foundationSource.locations.create(records, token);
      resolver.resolve(
        decoder: (JObject json) => SetBatchOut<Location>.des(json, Location.des),
        onConnectionFailure: () {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _conectionDialog(context,"Locations");
        },
        onException: (Object exception, StackTrace trace) {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _exceptionDialog(context, "Locations");
        },
        onFailure: (FailureFrame failure, int status) {},
        onSuccess: (SuccessFrame<SetBatchOut<Location>> success) {
          if (success.estela.failed) {
            feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
            _failureDialog(context, success.estela.failures.first.system, "Locations", success.estela.failures);
          } 
        },
      );
    }
    return feedback;
  }

  @override 
  Widget compose(BuildContext ctx, Size window){
    final TWSArticleCreatorAgent<Location> creatorAgent = TWSArticleCreatorAgent<Location>();
    return WhisperFrame(
      title: 'Create locations',
      trigger: creatorAgent.create,
      child: TWSArticleCreator<Location>(
        agent: creatorAgent,
        factory: Location.a,
        afterClose: () {
          LocationsArticle.tableAgent.refresh();
        }, 
        modelValidator: (Location model) {
          return model.evaluate().isEmpty;
        },
        onCreate: (List<Location> records) async {
          return _onCreateTrailers(records, ctx);
        },
        itemDesigner: (Location actualModel, bool selected, bool valid) {
          return _LocationStackItem(actualModel: actualModel, selected: selected, valid: valid );
        },
        formDesigner: (TWSArticleCreatorItemState<Location>? itemState) {  
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
                    maxLength: 100,
                    label: 'Name',
                    isStrictLength: false,
                    controller: TextEditingController(text: itemState?.model.name),
                    isEnabled: formDisabled,
                    onChanged: (String text) {
                      Location model = itemState!.model;
                      itemState.updateModelRedrawing(
                        model.clone(
                          name: text,
                        ),
                      );
                    },
                  ),
                  _LocationsCreateAddressForm(
                    itemState: itemState,
                    enable: formDisabled,
                  ),
                  _LocationsCreateWaypointForm(
                    itemState: itemState,
                    enable: formDisabled,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}