part of '../drivers_article.dart';
final class _DriversArticleState extends CSMStateBase {

  final TWSArticleTableAgent tableAgent;

  /// view filters initialization.
  List<SetViewFilterNodeInterface<Driver>> driversFilters = <SetViewFilterNodeInterface<Driver>>[];
  List<SetViewFilterNodeInterface<DriverExternal>> externalsFilters = <SetViewFilterNodeInterface<DriverExternal>>[];
  ///
  String nameFilter = '';

  ///
  String licenseFilter = '';

  ///
  String fatherFilter = '';

  ///
  String motherFilter = '';

  _DriversArticleState(this.tableAgent);

  filterName(String search) {
    nameFilter = search;

    _composeFilters();
  }

  filterLicense(String search) {
    licenseFilter = search;

    _composeFilters();
  }
  filterFather(String search) {
    fatherFilter = search;

    _composeFilters();
  }
  filterMother(String search) {
    motherFilter = search;

    _composeFilters();
  }

  _composeFilters() {
    driversFilters = <SetViewFilterNodeInterface<Driver>>[];
    externalsFilters = <SetViewFilterNodeInterface<DriverExternal>>[];

    if (licenseFilter.isNotEmpty) {
      SetViewPropertyFilter<Driver> lFilter = SetViewPropertyFilter<Driver>(0, SetViewFilterEvaluations.contians, 'DriverCommonNavigation.License', licenseFilter);
      SetViewPropertyFilter<DriverExternal> lFilterExternal = SetViewPropertyFilter<DriverExternal>(0, SetViewFilterEvaluations.contians, 'DriverCommonNavigation.License', licenseFilter);
      List<SetViewFilterInterface<Driver>> searchFilterFilters = <SetViewFilterInterface<Driver>>[
        lFilter,
      ];
      List<SetViewFilterInterface<DriverExternal>> externalSearchFilterFilters = <SetViewFilterInterface<DriverExternal>>[
        lFilterExternal,
      ];

      SetViewFilterLinearEvaluation<Driver> searchFilterOption = SetViewFilterLinearEvaluation<Driver>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      driversFilters.add(searchFilterOption);
      SetViewFilterLinearEvaluation<DriverExternal> externalSearchFilterOption = SetViewFilterLinearEvaluation<DriverExternal>(2, SetViewFilterEvaluationOperators.or, externalSearchFilterFilters);
      externalsFilters.add(externalSearchFilterOption);
    }

    if (nameFilter.isNotEmpty) {
      SetViewPropertyFilter<Driver> nFilter = SetViewPropertyFilter<Driver>(0, SetViewFilterEvaluations.contians, 'EmployeeNavigation.IdentificationNavigation.Name', nameFilter);
      SetViewPropertyFilter<DriverExternal> nFilterExternal = SetViewPropertyFilter<DriverExternal>(0, SetViewFilterEvaluations.contians, 'IdentificationNavigation.Name', nameFilter);
      List<SetViewFilterInterface<Driver>> searchFilterFilters = <SetViewFilterInterface<Driver>>[
        nFilter,
      ];
      List<SetViewFilterInterface<DriverExternal>> externalSearchFilterFilters = <SetViewFilterInterface<DriverExternal>>[
        nFilterExternal,
      ];

      SetViewFilterLinearEvaluation<Driver> searchFilterOption = SetViewFilterLinearEvaluation<Driver>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      driversFilters.add(searchFilterOption);
      SetViewFilterLinearEvaluation<DriverExternal> externalSearchFilterOption = SetViewFilterLinearEvaluation<DriverExternal>(2, SetViewFilterEvaluationOperators.or, externalSearchFilterFilters);
      externalsFilters.add(externalSearchFilterOption);
    }

    if (fatherFilter.isNotEmpty) {
      SetViewPropertyFilter<Driver> fFilter = SetViewPropertyFilter<Driver>(0, SetViewFilterEvaluations.contians, 'EmployeeNavigation.IdentificationNavigation.Fatherlastname', fatherFilter);
      SetViewPropertyFilter<DriverExternal> fFilterExternal = SetViewPropertyFilter<DriverExternal>(0, SetViewFilterEvaluations.contians, 'IdentificationNavigation.Fatherlastname', fatherFilter);
      List<SetViewFilterInterface<Driver>> searchFilterFilters = <SetViewFilterInterface<Driver>>[
        fFilter,
      ];
      List<SetViewFilterInterface<DriverExternal>> externalSearchFilterFilters = <SetViewFilterInterface<DriverExternal>>[
        fFilterExternal,
      ];

      SetViewFilterLinearEvaluation<Driver> searchFilterOption = SetViewFilterLinearEvaluation<Driver>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      driversFilters.add(searchFilterOption);
      SetViewFilterLinearEvaluation<DriverExternal> externalSearchFilterOption = SetViewFilterLinearEvaluation<DriverExternal>(2, SetViewFilterEvaluationOperators.or, externalSearchFilterFilters);
      externalsFilters.add(externalSearchFilterOption);
    }

    if (motherFilter.isNotEmpty) {
      SetViewPropertyFilter<Driver> mFilter = SetViewPropertyFilter<Driver>(0, SetViewFilterEvaluations.contians, 'EmployeeNavigation.IdentificationNavigation.Motherlastname', motherFilter);
      SetViewPropertyFilter<DriverExternal> mFilterExternal = SetViewPropertyFilter<DriverExternal>(0, SetViewFilterEvaluations.contians, 'IdentificationNavigation.Motherlastname', motherFilter);
      List<SetViewFilterInterface<Driver>> searchFilterFilters = <SetViewFilterInterface<Driver>>[
        mFilter,
      ];
      List<SetViewFilterInterface<DriverExternal>> externalSearchFilterFilters = <SetViewFilterInterface<DriverExternal>>[
        mFilterExternal,
      ];

      SetViewFilterLinearEvaluation<Driver> searchFilterOption = SetViewFilterLinearEvaluation<Driver>(2, SetViewFilterEvaluationOperators.or, searchFilterFilters);
      driversFilters.add(searchFilterOption);
      SetViewFilterLinearEvaluation<DriverExternal> externalSearchFilterOption = SetViewFilterLinearEvaluation<DriverExternal>(2, SetViewFilterEvaluationOperators.or, externalSearchFilterFilters);
      externalsFilters.add(externalSearchFilterOption);
    }

    effect();
    tableAgent.refresh();
  }
}