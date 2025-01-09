part of '../drivers_create_whisper.dart';

class _DriverStackItem extends StatelessWidget {
  final Driver actualModel;
  final bool selected;
  final bool valid;
  const _DriverStackItem({
    required this.actualModel,
    required this.selected,
    required this.valid,
  });

  @override
  Widget build(BuildContext context) {
    return TWSArticleCreationStackItem(
      selected: selected,
      valid: valid,
      properties: <TwsArticleCreationStackItemProperty>[
        TwsArticleCreationStackItemProperty(
          label: 'License',
          minWidth: 150,
          value: actualModel.driverCommonNavigation?.license ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Name',
          minWidth: 150,
          value: actualModel.employeeNavigation?.identificationNavigation?.name ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Father lastname',
          minWidth: 150,
          value: actualModel.employeeNavigation?.identificationNavigation?.fatherlastname ?? '---',
        ),
        TwsArticleCreationStackItemProperty(
          label: 'Mother lastname',
          minWidth: 150,
          value: actualModel.employeeNavigation?.identificationNavigation?.motherlastname ?? '---',
        ),

        if(actualModel.employeeNavigation?.identificationNavigation?.birthday != null)
        TwsArticleCreationStackItemProperty(
          label: 'Birthday',
          minWidth: 150,
          value: actualModel.employeeNavigation?.identificationNavigation?.birthday?.dateOnlyString ?? '---',
        ),

        if(actualModel.licenseExpiration != null)
        TwsArticleCreationStackItemProperty(
          label: 'License expiration',
          minWidth: 150,
          value: actualModel.licenseExpiration?.dateOnlyString ?? '---',
        ),

        if(actualModel.driverCommonNavigation?.situationNavigation?.name != null)
        TwsArticleCreationStackItemProperty(
          label: 'Situation',
          minWidth: 150,
          value: actualModel.driverCommonNavigation?.situationNavigation?.name ?? '---',
        ),

        if(actualModel.driverType != null)
        TwsArticleCreationStackItemProperty(
          label: 'Driver type',
          minWidth: 150,
          value: actualModel.driverType ?? '---',
        ),

        if(actualModel.drugalcRegistrationDate != null)
        TwsArticleCreationStackItemProperty(
          label: 'DrugAlc date',
          minWidth: 150,
          value: actualModel.drugalcRegistrationDate?.dateOnlyString ?? '---',
        ),

        if(actualModel.pullnoticeRegistrationDate != null)
        TwsArticleCreationStackItemProperty(
          label: 'Pull notice date',
          minWidth: 150,
          value: actualModel.pullnoticeRegistrationDate?.dateOnlyString ?? '---',
        ),

        if(actualModel.twic != null)
        TwsArticleCreationStackItemProperty(
          label: 'TWIC',
          minWidth: 150,
          value: actualModel.twic ?? '---',
        ),

        if(actualModel.twicExpiration != null)
        TwsArticleCreationStackItemProperty(
          label: 'TWIC expiration',
          minWidth: 150,
          value: actualModel.twicExpiration?.dateOnlyString ?? '---',
        ),

        if(actualModel.visa != null)
        TwsArticleCreationStackItemProperty(
          label: 'VISA',
          minWidth: 150,
          value: actualModel.visa ?? '---',
        ),

        if(actualModel.visaExpiration != null)
        TwsArticleCreationStackItemProperty(
          label: 'VISA expiration',
          minWidth: 150,
          value: actualModel.visaExpiration?.dateOnlyString ?? '---',
        ),

        if(actualModel.fast != null)
        TwsArticleCreationStackItemProperty(
          label: 'FAST',
          minWidth: 150,
          value: actualModel.fast ?? '---',
        ),

        if(actualModel.fastExpiration != null)
        TwsArticleCreationStackItemProperty(
          label: 'FAST expiration',
          minWidth: 150,
          value: actualModel.fastExpiration?.dateOnlyString ?? '---',
        ),

        if(actualModel.anam != null)
        TwsArticleCreationStackItemProperty(
          label: 'ANAM',
          minWidth: 150,
          value: actualModel.anam ?? '---',
        ),

        if(actualModel.anamExpiration != null)
        TwsArticleCreationStackItemProperty(
          label: 'ANAM expiration',
          minWidth: 150,
          value: actualModel.anamExpiration?.dateOnlyString ?? '---',
        ),

        if(actualModel.employeeNavigation?.approachNavigation?.email != null)
        TwsArticleCreationStackItemProperty(
          label: 'Email',
          minWidth: 150,
          value: actualModel.employeeNavigation?.approachNavigation?.email ?? '---',
        ),

        if(actualModel.employeeNavigation?.approachNavigation?.enterprise != null)
        TwsArticleCreationStackItemProperty(
          label: 'Enterprise phone',
          minWidth: 150,
          value: actualModel.employeeNavigation?.approachNavigation?.enterprise ?? '---',
        ),

        if(actualModel.employeeNavigation?.approachNavigation?.personal != null)
        TwsArticleCreationStackItemProperty(
          label: 'Personal phone',
          minWidth: 150,
          value: actualModel.employeeNavigation?.approachNavigation?.personal ?? '---',
        ),

        if(actualModel.employeeNavigation?.approachNavigation?.alternative != null)
        TwsArticleCreationStackItemProperty(
          label: 'Alt. contact',
          minWidth: 150,
          value: actualModel.employeeNavigation?.approachNavigation?.alternative ?? '---',
        ),
        
        if(actualModel.employeeNavigation?.addressNavigation?.country != null)
        TwsArticleCreationStackItemProperty(
          label: 'Country',
          minWidth: 150,
          value: actualModel.employeeNavigation?.addressNavigation?.country ?? '---',
        ),

        if(actualModel.employeeNavigation?.addressNavigation?.state != null)
        TwsArticleCreationStackItemProperty(
          label: 'State',
          minWidth: 150,
          value: actualModel.employeeNavigation?.addressNavigation?.state ?? '---',
        ),

        if(actualModel.employeeNavigation?.addressNavigation?.street != null)
        TwsArticleCreationStackItemProperty(
          label: 'Street',
          minWidth: 150,
          value: actualModel.employeeNavigation?.addressNavigation?.street ?? '---',
        ),

        if(actualModel.employeeNavigation?.addressNavigation?.altStreet != null)
        TwsArticleCreationStackItemProperty(
          label: 'Alt. street',
          minWidth: 150,
          value: actualModel.employeeNavigation?.addressNavigation?.altStreet ?? '---',
        ),

        if(actualModel.employeeNavigation?.addressNavigation?.city != null)
        TwsArticleCreationStackItemProperty(
          label: 'City',
          minWidth: 150,
          value: actualModel.employeeNavigation?.addressNavigation?.city ?? '---',
        ),

        if(actualModel.employeeNavigation?.addressNavigation?.zip != null)
        TwsArticleCreationStackItemProperty(
          label: 'ZIP',
          minWidth: 150,
          value: actualModel.employeeNavigation?.addressNavigation?.zip ?? '---',
        ),

        if(actualModel.employeeNavigation?.addressNavigation?.colonia != null)
        TwsArticleCreationStackItemProperty(
          label: 'Colonia',
          minWidth: 150,
          value: actualModel.employeeNavigation?.addressNavigation?.colonia ?? '---',
        ),
      ],
    );
  }
}
