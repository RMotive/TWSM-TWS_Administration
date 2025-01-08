import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/constants/twsa_common_displays.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';
import 'package:tws_administration_view/data/services/sources.dart';
import 'package:tws_administration_view/data/storages/session_storage.dart';
import 'package:tws_administration_view/view/articles/trailers/trailers_article.dart';
import 'package:tws_administration_view/view/frames/whisper/whisper_frame.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/records_stack/tws_article_creator_stack_item.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/records_stack/tws_article_creator_stack_item_property.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_agent.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_creation_item_state.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_creator.dart';
import 'package:tws_administration_view/view/widgets/tws_article_creation/tws_article_creator_feedback.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_adapter.dart';
import 'package:tws_administration_view/view/widgets/tws_autocomplete_field/tws_autocomplete_field.dart';
import 'package:tws_administration_view/view/widgets/tws_button_flat.dart';
import 'package:tws_administration_view/view/widgets/tws_cascade_section.dart';
import 'package:tws_administration_view/view/widgets/tws_confirmation_dialog.dart';
import 'package:tws_administration_view/view/widgets/tws_datepicker_field.dart';
import 'package:tws_administration_view/view/widgets/tws_incremental_list.dart';
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_administration_view/view/widgets/tws_section.dart';
import 'package:tws_administration_view/view/widgets/tws_section_divider.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

part '../options/adapters/trailers_whisper_options_adapter.dart';
part 'forms/trailers/trailers_create_type_form.dart';
part 'forms/trailers/trailers_create_main_form.dart';
part 'forms/trailers/trailers_create_maintenance_form.dart';
part 'forms/trailers/trailers_create_manufacturer_form.dart';
part 'forms/trailers/trailers_create_plates_form.dart';
part 'forms/trailers/trailers_create_sct_form.dart';
part 'forms/trailers/trailers_create_situation_form.dart';
part 'forms/trailers_form.dart';

part 'forms/trailer_external_form.dart';
part 'forms/trailer_stack_item.dart';
part 'forms/trailer_external_stack_item.dart';
part 'forms/trailers/trailers_create_plates_section.dart';
part 'forms/dialogs.dart';

class _MainFormState extends CSMStateBase {}
final _MainFormState _mainFormState = _MainFormState();

const List<String> _countryOptions = TWSAMessages.kCountryList;
const List<String> _usaStateOptions = TWSAMessages.kUStateCodes;
const List<String> _mxStateOptions = TWSAMessages.kMXStateCodes;
final DateTime _firstDate = DateTime(2000);
final DateTime _lastlDate = DateTime(2040);
final DateTime _today = DateTime.now();
late void Function() _formState;


String _displayModel(VehiculeModel? vehiculeModel){
  String data = "---";
  if(vehiculeModel != null){
    if(vehiculeModel.manufacturerNavigation != null) data = "${vehiculeModel.manufacturerNavigation!.name} - ${vehiculeModel.name} ${vehiculeModel.year.year}";
  }
  return data;
}

class TrailersCreateWhisper extends CSMPageBase{
  const TrailersCreateWhisper({super.key});

  Future<List<TWSArticleCreatorFeedback>> _onCreateTrailers(List<Object> records, BuildContext context) async {
    final String token = _sessionStorage.getTokenStrict();
    List<TWSArticleCreatorFeedback> feedback = <TWSArticleCreatorFeedback>[];
    List<Trailer> trailerList = <Trailer>[];
    List<TrailerExternal> externalList = <TrailerExternal>[];
    for(Object record in records){
      if(record is Trailer) trailerList.add(record);
      if(record is TrailerExternal) externalList.add(record);
    }

    // --> Create trailers.
    if(trailerList.isNotEmpty){
      MainResolver<SetBatchOut<Trailer>> resolver = await Sources.foundationSource.trailers.create(trailerList, token);
      resolver.resolve(
        decoder: (JObject json) => SetBatchOut<Trailer>.des(json, Trailer.des),
        onConnectionFailure: () {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _conectionDialog(context,"Trailers");
        },
        onException: (Object exception, StackTrace trace) {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _exceptionDialog(context, "Trailers");
        },
        onFailure: (FailureFrame failure, int status) {},
        onSuccess: (SuccessFrame<SetBatchOut<Trailer>> success) {
          if (success.estela.failed) {
            feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
            _failureDialog(context, success.estela.failures.first.system, "Trailers", success.estela.failures);
          } 
        },
      );
    }

    // --> Create External trailers.
    if(externalList.isNotEmpty){
      MainResolver<SetBatchOut<TrailerExternal>> externalResolver = await Sources.foundationSource.trailersExternals.create(externalList, token);
      externalResolver.resolve(
        decoder: (JObject json) => SetBatchOut<TrailerExternal>.des(json, TrailerExternal.des),
        onConnectionFailure: () {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _conectionDialog(context, "External Trailers");
        },
        onException: (Object exception, StackTrace trace) {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _exceptionDialog(context, "External Trailers");
        },
        onFailure: (FailureFrame failure, int status) {},
        onSuccess: (SuccessFrame<SetBatchOut<TrailerExternal>> success) {
          if (success.estela.failed) {
            feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
            _failureDialog(context, success.estela.failures.first.system, "External Trailers", success.estela.failures);
          }
        },
      );
    }
    return feedback;
  }

  @override 
  Widget compose(BuildContext ctx, Size window){
    final TWSArticleCreatorAgent<TrailerExternal> creatorAgent = TWSArticleCreatorAgent<TrailerExternal>();
    CSMColorThemeOptions themeSctruct = getTheme<TWSAThemeBase>().primaryControlColor;
    TextStyle sectionsLinesStyle =  TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 12,
      color: themeSctruct.hightlightAlt ?? Colors.white,
      fontStyle: FontStyle.italic
    );
    return WhisperFrame(
      title: 'Create trailers',
      trigger: creatorAgent.create,
      child: TWSArticleCreator<Object>(
        agent: creatorAgent,
        factory: Trailer.a,
        afterClose: () {
          TrailersArticle.tableAgent.refresh();
        }, 
        modelValidator: (Object model) {
          if(model is Trailer) return model.evaluate().isEmpty;
          if(model is TrailerExternal) return model.evaluate().isEmpty;
          return true;
        },
        onCreate: (List<Object> records) async {
          return _onCreateTrailers(records, ctx);
        },
        itemDesigner: (Object actualModel, bool selected, bool valid) {
          if(actualModel is Trailer)  return _TrailerStackItem(actualModel: actualModel, selected: selected, valid: valid );
          if(actualModel is TrailerExternal) return _TrailerExternalStackItem(actualModel: actualModel, selected: selected, valid: valid);
          return const Text('Invalid Model');
        },
        formDesigner: (TWSArticleCreatorItemState<Object>? itemState) {  
          final bool formDisabled = !(itemState == null);
          final ScrollController scrollController = ScrollController();
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CSMDynamicWidget<_MainFormState>(
                state: _mainFormState, 
                designer: (BuildContext ctx, _MainFormState state) {
                  _formState = state.effect;
                  return CSMSpacingColumn(
                    spacing: 10,
                    children: <Widget>[
                      CSMSpacingRow(
                        spacing: 10,
                        children: <Widget>[
                          Expanded(
                            child: TWSButtonFlat(
                              disabled: (itemState?.model is Trailer || itemState == null),
                              label: "Trailer",
                              onTap: () {
                                itemState!.updateFactory(Trailer.a);
                                _formState();
                              },
                            ),
                          ),
                          Expanded(
                            child: TWSButtonFlat(
                              disabled: (itemState?.model is TrailerExternal || itemState == null),
                              label: "External Trailer",
                              onTap: () {
                                itemState!.updateFactory(TrailerExternal.a);
                                _formState();
                              },
                            ),
                          ),
                        ]
                      ),
                      if(itemState != null)
                      itemState.model is Trailer? _TrailerForm(
                        itemState: itemState,
                        style: sectionsLinesStyle,
                        formDisabled: formDisabled,
                      )
                      : _TrailerExternalForm(
                        style: sectionsLinesStyle, 
                        item: itemState.model as TrailerExternal,
                        formDisabled: formDisabled,
                        itemState: itemState,
                      ),
                    ],
                  );
                },
              ),     
            ),
          );
        },
      ),
    );
  }
}