import 'package:csm_view/csm_view.dart';

/// Stores all the route options objects for use the [RouteDriver] and
/// initialize the route tree of the application.
///
/// NOTE: remember that if you want to use the [RouteDriver] you should use this instance objects
/// case that manager uses a combination of calculations and hashcode of [RouteOptions] objects
/// to generate absolute pathing and another behaviors.
final class TWSARoutes {
  static const CSMRouteOptions loginPage = CSMRouteOptions('/');
  static const CSMRouteOptions overviewPage = CSMRouteOptions('overview');
  static const CSMRouteOptions securityPage = CSMRouteOptions('security');
  static const CSMRouteOptions businessPage = CSMRouteOptions('business');
  static const CSMRouteOptions yardlogPage = CSMRouteOptions('yard-logs');

  static const CSMRouteOptions settings = CSMRouteOptions('settings');
  static const CSMRouteOptions profile = CSMRouteOptions('profile');
  static const CSMRouteOptions about = CSMRouteOptions('about');

  static const CSMRouteOptions featuresArticle = CSMRouteOptions('features');
  static const CSMRouteOptions featuresCreateWhisper = CSMRouteOptions('create');

  static const CSMRouteOptions solutionsArticle = CSMRouteOptions('solutions');
  static const CSMRouteOptions solutionsCreateWhisper = CSMRouteOptions(name: 'solutions-create', 'create');

  static const CSMRouteOptions trucksArticle = CSMRouteOptions('trucks');
  static const CSMRouteOptions trucksCreateWhisper = CSMRouteOptions('add');
  static const CSMRouteOptions trucksViewWhisper = CSMRouteOptions(name: 'trucks-view', 'view');

  static const CSMRouteOptions manufacturersArticle = CSMRouteOptions('manufacturers');
  static const CSMRouteOptions manufacturersViewWhisper = CSMRouteOptions(name: 'manufacturers-view', 'view');
  static const CSMRouteOptions manufacturersCreateWhisper = CSMRouteOptions(name: 'manufacturers-create', 'create');

  static const CSMRouteOptions platesArticle = CSMRouteOptions('plates');
  static const CSMRouteOptions platesViewWhisper = CSMRouteOptions(name: 'plates-view', 'view');
  static const CSMRouteOptions platesCreateWhisper = CSMRouteOptions(name: 'plates-create', 'create');

  static const CSMRouteOptions insuranceArticle = CSMRouteOptions('insurances');
  static const CSMRouteOptions insuranceViewWhisper = CSMRouteOptions(name: 'insurances-view', 'view');

  static const CSMRouteOptions maintencesArticle = CSMRouteOptions('mainteneces');
  static const CSMRouteOptions maintenecesViewWhisper = CSMRouteOptions(name: 'maintenences-view', 'view');

  static const CSMRouteOptions sctsArticle = CSMRouteOptions('scts');
  static const CSMRouteOptions sctsViewWhisper = CSMRouteOptions(name: 'scts-view', 'view');

  static const CSMRouteOptions situationsArticle = CSMRouteOptions('situations');
  static const CSMRouteOptions situationsViewWhisper = CSMRouteOptions(name: 'situations-view', 'view');

  static const CSMRouteOptions yardlogsArticle = CSMRouteOptions('yardlogs');
  static const CSMRouteOptions yardlogsViewWhisper = CSMRouteOptions(name: 'yardlogs-view', 'view');

  static const CSMRouteOptions yardlogsTruckInventoryArticle = CSMRouteOptions('trucks-inventory');


  // --> HUMAN RESOURCES
  static const CSMRouteOptions humanResourcesPage = CSMRouteOptions('human-resources');
  static const CSMRouteOptions contactsArticle = CSMRouteOptions('contacts');
  static const CSMRouteOptions contactsCreateWhisper = CSMRouteOptions('contacts-create');

}
