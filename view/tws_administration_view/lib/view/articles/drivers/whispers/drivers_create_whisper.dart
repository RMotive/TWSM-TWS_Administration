import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/constants/twsa_common_displays.dart';
import 'package:tws_administration_view/core/theme/bases/twsa_theme_base.dart';
import 'package:tws_administration_view/data/services/sources.dart';
import 'package:tws_administration_view/data/storages/session_storage.dart';
import 'package:tws_administration_view/view/articles/drivers/drivers_article.dart';
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
import 'package:tws_administration_view/view/widgets/tws_input_text.dart';
import 'package:tws_administration_view/view/widgets/tws_section.dart';
import 'package:tws_administration_view/view/widgets/tws_section_divider.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

part 'forms/driver_stack_item.dart';
part 'forms/driver_external_stack_item.dart';
part 'forms/driver_from.dart';
part 'forms/dialogs.dart';
part 'forms/drivers/drivers_create_main_form.dart';
part 'forms/drivers/drivers_create_employee_form.dart';
part 'forms/drivers/drivers_create_address_form.dart';
part 'forms/drivers/drivers_create_approach_form.dart';

part 'forms/driver_external_form.dart';
part '../options/adapters/drivers_whisper_options_adapter.dart';

class _MainFormState extends CSMStateBase {}
final _MainFormState _mainFormState = _MainFormState();
const List<String> _countryOptions = TWSAMessages.kCountryList;
const List<String> _usaStateOptions = TWSAMessages.kUStateCodes;
const List<String> _mxStateOptions = TWSAMessages.kMXStateCodes;
final DateTime _firstDate = DateTime(2000);
final DateTime _lastlDate = DateTime(2040);
late void Function() _formState;

class DriversCreateWhisper  extends CSMPageBase{
  const DriversCreateWhisper({super.key});

  Future<List<TWSArticleCreatorFeedback>> _onCreateDrivers(List<Object> records, BuildContext context) async {
    final String token = _sessionStorage.getTokenStrict();
    List<TWSArticleCreatorFeedback> feedback = <TWSArticleCreatorFeedback>[];
    List<Driver> driversList = <Driver>[];
    List<DriverExternal> externalList = <DriverExternal>[];
    for(Object record in records){
      if(record is Driver) driversList.add(record);
      if(record is DriverExternal) externalList.add(record);
    }

    // --> Create trailers.
    if(driversList.isNotEmpty){
      MainResolver<SetBatchOut<Driver>> resolver = await Sources.foundationSource.drivers.create(driversList, token);
      resolver.resolve(
        decoder: (JObject json) => SetBatchOut<Driver>.des(json, Driver.des),
        onConnectionFailure: () {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _conectionDialog(context,"Drivers");
        },
        onException: (Object exception, StackTrace trace) {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _exceptionDialog(context, "Drivers");
        },
        onFailure: (FailureFrame failure, int status) {},
        onSuccess: (SuccessFrame<SetBatchOut<Driver>> success) {
          if (success.estela.failed) {
            feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
            _failureDialog(context, success.estela.failures.first.system, "Drivers", success.estela.failures);
          } 
        },
      );
    }

    // --> Create External trailers.
    if(externalList.isNotEmpty){
      MainResolver<SetBatchOut<DriverExternal>> externalResolver = await Sources.foundationSource.driversExternals.create(externalList, token);
      externalResolver.resolve(
        decoder: (JObject json) => SetBatchOut<DriverExternal>.des(json, DriverExternal.des),
        onConnectionFailure: () {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _conectionDialog(context, "External Drivers");
        },
        onException: (Object exception, StackTrace trace) {
          feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
          _exceptionDialog(context, "External Drivers");
        },
        onFailure: (FailureFrame failure, int status) {},
        onSuccess: (SuccessFrame<SetBatchOut<DriverExternal>> success) {
          if (success.estela.failed) {
            feedback.add(const TWSArticleCreatorFeedback(TWSArticleCreatorFeedbackTypes.error));
            _failureDialog(context, success.estela.failures.first.system, "External Drivers", success.estela.failures);
          }
        },
      );
    }
    return feedback;
  }

  @override 
  Widget compose(BuildContext ctx, Size window){
    final TWSArticleCreatorAgent<Driver> creatorAgent = TWSArticleCreatorAgent<Driver>();
    CSMColorThemeOptions themeSctruct = getTheme<TWSAThemeBase>().primaryControlColor;
    TextStyle sectionsLinesStyle =  TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 12,
      color: themeSctruct.hightlightAlt ?? Colors.white,
      fontStyle: FontStyle.italic
    );
    return WhisperFrame(
      title: 'Create drivers',
      trigger: creatorAgent.create,
      child: TWSArticleCreator<Object>(
        agent: creatorAgent,
        factory: Driver.a,
        afterClose: () {
          DriversArticle.tableAgent.refresh();
        }, 
        modelValidator: (Object model) {
          if(model is Driver) return model.evaluate().isEmpty;
          if(model is DriverExternal) return model.evaluate().isEmpty;
          return true;
        },
        onCreate: (List<Object> records) async {
          return _onCreateDrivers(records, ctx);
        },
        itemDesigner: (Object actualModel, bool selected, bool valid) {
          if(actualModel is Driver)  return _DriverStackItem(actualModel: actualModel, selected: selected, valid: valid );
          if(actualModel is DriverExternal) return _DriverExternalStackItem(actualModel: actualModel, selected: selected, valid: valid);
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
                              disabled: (itemState?.model is Driver || itemState == null),
                              label: "Driver",
                              onTap: () {
                                itemState!.updateFactory(Driver.a);
                                _formState();
                              },
                            ),
                          ),
                          Expanded(
                            child: TWSButtonFlat(
                              disabled: (itemState?.model is DriverExternal|| itemState == null),
                              label: "External Driver",
                              onTap: () {
                                itemState!.updateFactory(DriverExternal.a);
                                _formState();
                              },
                            ),
                          ),
                        ]
                      ),
                      if(itemState != null)
                      itemState.model is Driver? _DriverForm(
                        itemState: itemState,
                        style: sectionsLinesStyle,
                        formDisabled: formDisabled,
                      )
                      : _DriversExternalForm(
                        style: sectionsLinesStyle, 
                        item: itemState.model as DriverExternal,
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