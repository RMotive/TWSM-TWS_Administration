import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/router/twsa_routes.dart';
import 'package:tws_administration_view/view/articles/drivers/drivers_article.dart';
import 'package:tws_administration_view/view/articles/drivers/whispers/drivers_create_whisper.dart';
import 'package:tws_administration_view/view/articles/features/features_article.dart';
import 'package:tws_administration_view/view/articles/features/whispers/create/features_create_whisper.dart';
import 'package:tws_administration_view/view/articles/locations/locations_article.dart';
import 'package:tws_administration_view/view/articles/locations/whispers/locations_create_whisper.dart';
import 'package:tws_administration_view/view/articles/solutions/solutions_article.dart';
import 'package:tws_administration_view/view/articles/solutions/whispers/solutions_create_whisper.dart';
import 'package:tws_administration_view/view/articles/trailers/trailers_article.dart';
import 'package:tws_administration_view/view/articles/trailers/whispers/trailers_create_whisper.dart';
import 'package:tws_administration_view/view/articles/trucks/trucks_article.dart';
import 'package:tws_administration_view/view/articles/trucks/whispers/trucks_create_whisper.dart';
import 'package:tws_administration_view/view/articles/yardlogs/truck_inventory_article.dart';
import 'package:tws_administration_view/view/layouts/master/master_layout.dart';
import 'package:tws_administration_view/view/pages/about/about_page.dart';
import 'package:tws_administration_view/view/pages/business/business_page.dart';
import 'package:tws_administration_view/view/pages/human_resources/articles/contacts/contacts_article.dart';
import 'package:tws_administration_view/view/pages/human_resources/human_resources_page.dart';
import 'package:tws_administration_view/view/pages/login/login_page.dart';
import 'package:tws_administration_view/view/pages/overview/overview_page.dart';
import 'package:tws_administration_view/view/pages/profile/profile_page.dart';
import 'package:tws_administration_view/view/pages/security/security_page.dart';
import 'package:tws_administration_view/view/pages/settings/settings_page.dart';
import 'package:tws_administration_view/view/pages/yardlog/yardlog_page.dart';

typedef Routes = TWSARoutes;

class TWSARouteTree extends CSMRouterTreeBase {
  TWSARouteTree()
      : super(
          devRoute: Routes.locationsArticle,
          redirect: (_, __) {
            return null;
          },
          routes: <CSMRouteBase>[
            // --> [Login Page]
            CSMRouteNode(
              Routes.loginPage,
              redirect: (_, __) async {
                return null;
              },
              pageBuild: (_, __) => const LoginPage(),
            ),
            // --> [MasterLayout]
            CSMRouteLayout(
              layoutBuild: (_, CSMRouterOutput output, Widget page) {
                return MasterLayout(
                  page: page,
                  rOutput: output,
                );
              },
              routes: <CSMRouteBase>[
                // --> [Overview Page]
                CSMRouteNode(
                  Routes.overviewPage,
                  pageBuild: (_, __) => const OverviewPage(),
                ),
                // --> [About page]
                CSMRouteNode(
                  Routes.about,
                  pageBuild: (_, __) => const AboutPage(),
                ),
                // --> [Profile user page]
                CSMRouteNode(
                  Routes.profile,
                  pageBuild: (_, __) => const ProfilePage(),
                ),
                // --> [User settings page]
                CSMRouteNode(
                  Routes.settings,
                  pageBuild: (_, __) => const SettingsPage(),
                ),
                // --> [Security Page]
                CSMRouteNode(
                  Routes.securityPage,
                  pageBuild: (_, __) {
                    return const SecurityPage(
                      currentRoute: Routes.securityPage,
                    );
                  },
                  routes: <CSMRouteBase>[
                    // --> [Features]
                    CSMRouteNode(
                      Routes.featuresArticle,
                      pageBuild: (_, __) {
                        return const FeaturesArticle();
                      },
                      routes: <CSMRouteBase>[
                        CSMRouteWhisper<Object>(
                          Routes.featuresCreateWhisper,
                          whisperOptions: const CSMRouteWhisperOptions(),
                          pageBuild: (BuildContext ctx, CSMRouterOutput output) => const FeaturesCreateWhisper(),
                        ),
                      ],
                    ),
                    // --> [Solutions]
                    CSMRouteNode(
                      TWSARoutes.solutionsArticle,
                      pageBuild: (BuildContext ctx, CSMRouterOutput output) => const SolutionsArticle(),
                      routes: <CSMRouteBase>[
                        // --> [Create]
                        CSMRouteWhisper<void>(
                          TWSARoutes.solutionsCreateWhisper,
                          whisperOptions: const CSMRouteWhisperOptions(
                            padding: EdgeInsets.zero,
                          ),
                          pageBuild: (BuildContext ctx, CSMRouterOutput output) => const SolutionsCreateWhisper(),
                        ),
                      ],
                    ),
                  ],
                ),
                // --> [Business Page]
                CSMRouteNode(
                  Routes.businessPage,
                  pageBuild: (_, __) {
                    return const BusinessPage(
                      currentRoute: Routes.businessPage,
                    );
                  },
                  routes: <CSMRouteBase>[
                    // --> [Trucks]
                    CSMRouteNode(
                      Routes.trucksArticle,
                      pageBuild: (_, __) => const TrucksArticle(),
                      routes: <CSMRouteBase>[
                        // -> [Create]
                        CSMRouteWhisper<Object>(
                          Routes.trucksCreateWhisper,
                          whisperOptions: const CSMRouteWhisperOptions(
                            padding: EdgeInsets.zero,
                          ),
                          pageBuild: (BuildContext ctx, CSMRouterOutput output) => const TrucksCreateWhisper(),
                        ),
                      ],
                    ),
                    // --> [Trailers]
                    CSMRouteNode(
                      Routes.trailersArticle,
                      pageBuild: (_, __) => const TrailersArticle(),
                      routes: <CSMRouteBase>[
                        // -> [Create]
                        CSMRouteWhisper<Object>(
                          Routes.trailersCreateWhisper,
                          whisperOptions: const CSMRouteWhisperOptions(
                            padding: EdgeInsets.zero,
                          ),
                          pageBuild: (BuildContext ctx, CSMRouterOutput output) => const TrailersCreateWhisper(),
                        ),
                      ],
                    ),

                    // --> [Drivers]
                    CSMRouteNode(
                      Routes.driversArticle,
                      pageBuild: (_, __) => const DriversArticle(),
                      routes: <CSMRouteBase>[
                        // -> [Create]
                        CSMRouteWhisper<Object>(
                          Routes.driversCreateWhisper,
                          whisperOptions: const CSMRouteWhisperOptions(
                            padding: EdgeInsets.zero,
                          ),
                          pageBuild: (BuildContext ctx, CSMRouterOutput output) => const DriversCreateWhisper(),
                        ),
                      ],
                    ),

                    // --> [Locations]
                    CSMRouteNode(
                      Routes.locationsArticle,
                      pageBuild: (_, __) => const LocationsArticle(),
                      routes: <CSMRouteBase>[
                        // --> [Create]
                        CSMRouteWhisper<Object>(
                          Routes.locationsCreateWhisper,
                          whisperOptions: const CSMRouteWhisperOptions(
                            padding: EdgeInsets.zero,
                          ),
                          pageBuild: (BuildContext ctx, CSMRouterOutput output) => const LocationsCreateWhisper(),
                        ),
                      ],
                    ),
                  ],
                ),
                // --> [Human Resources Page]
                CSMRouteNode(
                  Routes.humanResourcesPage,
                  pageBuild: (_, __) {
                    return const HumanResourcesPage();
                  },
                  routes: <CSMRouteBase>[
                    CSMRouteNode(
                      TWSARoutes.contactsArticle,
                      pageBuild: (BuildContext ctx, CSMRouterOutput output) => const ContactsArticle(),
                    ),
                  ],
                ),
                // --> [Yardlog page]
                CSMRouteNode(
                  Routes.yardlogPage, 
                  pageBuild: (_, CSMRouterOutput routerOutput) {
                    return const YardlogPage(
                      currentRoute: Routes.yardlogPage,
                    );
                  }, 
                  routes: <CSMRouteBase>[
                    // -> [Trucks inventory]
                    CSMRouteNode(
                      Routes.yardlogsTruckInventoryArticle,
                      pageBuild: (_, CSMRouterOutput routerOutput) {
                        return const TruckInventoryArticle(
                          currentRoute: Routes.yardlogPage,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
}
