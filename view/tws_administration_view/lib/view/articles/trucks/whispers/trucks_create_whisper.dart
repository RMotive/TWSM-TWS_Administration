import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/constants/twsa_common_displays.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';
import 'package:tws_administration_view/data/services/sources.dart';
import 'package:tws_administration_view/data/storages/session_storage.dart';
import 'package:tws_administration_view/view/articles/trucks/trucks_article.dart';
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

part '../options/adapters/trucks_whisper_options_adapter.dart';
part 'forms/trucks/trucks_create_insurance_form.dart';
part 'forms/trucks/trucks_create_main_form.dart';
part 'forms/trucks/trucks_create_maintenance_form.dart';
part 'forms/trucks/trucks_create_manufacturer_form.dart';
part 'forms/trucks/trucks_create_plates_form.dart';
part 'forms/trucks/trucks_create_sct_form.dart';
part 'forms/trucks/trucks_create_situation_form.dart';
part 'forms/truck_form.dart';
part 'forms/truck_external_form.dart';
part 'forms/truck_stack_item.dart';
part 'forms/truck_external_stack_item.dart';
part 'forms/trucks/trucks_create_plates_section.dart';
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

class TrucksCreateWhisper extends CSMPageBase{
  const TrucksCreateWhisper({super.key});

  Future<List<TWSArticleCreatorFeedback>> _onCreateTrucks(List<Object> records, BuildContext context) async {
    final String token = _sessionStorage.getTokenStrict();
    List<TWSArticleCreatorFeedback> feedback = <TWSArticleCreatorFeedback>[];
    List<Truck> truckList = <Truck>[];
    List<TruckExternal> externalList = <TruckExternal>[];
    for(Object record in records){
      if(record is Truck) truckList.add(record);
      if(record is TruckExternal) externalList.add(record);
    }

    // --> Create trucks.
    if(truckList.isNotEmpty){
      MainResolver<SetBatchOut<Truck>> resolver = await Sources.foundationSource.trucks.create(truckList, token);
      resolver.resolve(
        decoder: (JObject json) => SetBatchOut<Truck>.des(json, Truck.des),
        onConnectionFailure: () {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _conectionDialog(context,"Trucks");
        },
        onException: (Object exception, StackTrace trace) {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _exceptionDialog(context, "Trucks");
        },
        onFailure: (FailureFrame failure, int status) {},
        onSuccess: (SuccessFrame<SetBatchOut<Truck>> success) {
          if (success.estela.failed) {
            feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
            _failureDialog(context, success.estela.failures.first.system, "Trucks", success.estela.failures);
          } 
        },
      );
    }

    // --> Create External trucks.
    if(externalList.isNotEmpty){
      MainResolver<SetBatchOut<TruckExternal>> externalResolver = await Sources.foundationSource.trucksExternals.create(externalList, token);
      externalResolver.resolve(
        decoder: (JObject json) => SetBatchOut<TruckExternal>.des(json, TruckExternal.des),
        onConnectionFailure: () {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _conectionDialog(context, "External Trucks");
        },
        onException: (Object exception, StackTrace trace) {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _exceptionDialog(context, "External Trucks");
        },
        onFailure: (FailureFrame failure, int status) {},
        onSuccess: (SuccessFrame<SetBatchOut<TruckExternal>> success) {
          if (success.estela.failed) {
            feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
            _failureDialog(context, success.estela.failures.first.system, "External Trucks", success.estela.failures);
          }
        },
      );
    }
    return feedback;
  }

  @override 
  Widget compose(BuildContext ctx, Size window){
    final TWSArticleCreatorAgent<Truck> creatorAgent = TWSArticleCreatorAgent<Truck>();
    CSMColorThemeOptions themeSctruct = getTheme<TWSAThemeBase>().primaryControlColor;
    TextStyle sectionsLinesStyle =  TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 12,
      color: themeSctruct.hightlightAlt ?? Colors.white,
      fontStyle: FontStyle.italic
    );
    return WhisperFrame(
      title: 'Create trucks',
      trigger: creatorAgent.create,
      child: TWSArticleCreator<Object>(
        agent: creatorAgent,
        factory: Truck.a,
        afterClose: () {
          tableAgent.refresh();
        }, 
        modelValidator: (Object model) {
          if(model is Truck) return model.evaluate().isEmpty;
          if(model is TruckExternal) return model.evaluate().isEmpty;
          return true;
        },
        onCreate: (List<Object> records) async {
          return _onCreateTrucks(records, ctx);
        },
        itemDesigner: (Object actualModel, bool selected, bool valid) {
          if(actualModel is Truck)  return _TruckStackItem(actualModel: actualModel, selected: selected, valid: valid );
          if(actualModel is TruckExternal) return _TruckExternalStackItem(actualModel: actualModel, selected: selected, valid: valid);
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
                              disabled: (itemState?.model is Truck || itemState == null),
                              label: "Truck",
                              onTap: () {
                                itemState!.updateFactory(Truck.a);
                                _formState();
                              },
                            ),
                          ),
                          Expanded(
                            child: TWSButtonFlat(
                              disabled: (itemState?.model is TruckExternal || itemState == null),
                              label: "External Truck",
                              onTap: () {
                                itemState!.updateFactory(TruckExternal.a);
                                _formState();
                              },
                            ),
                          ),
                        ]
                      ),
                      if(itemState != null)
                      itemState.model is Truck? _TruckForm(
                        itemState: itemState,
                        style: sectionsLinesStyle,
                        formDisabled: formDisabled,
                      )
                      : _TruckExternalForm(
                        style: sectionsLinesStyle, 
                        item: itemState.model as TruckExternal,
                        formDisabled: formDisabled,
                        itemState: itemState,
                      ),
                    ]
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