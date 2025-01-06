import 'package:csm_view/csm_view.dart';
import 'package:flutter/material.dart';
import 'package:tws_administration_view/core/router/twsa_routes.dart';
import 'package:tws_administration_view/view/frames/article/action_ribbon_options.dart';
import 'package:tws_administration_view/view/frames/article/article_frame.dart';
import 'package:tws_administration_view/view/frames/article/article_options.dart';

class BusinessFrame extends StatelessWidget {
  final Widget? article;
  final CSMRouteOptions currentRoute;
  final ActionRibbonOptions? actionsOptions;

  const BusinessFrame({
    super.key,
    this.article,
    this.actionsOptions,
    required this.currentRoute,
  });

  /// Stores all the articles configured for Business.
  static final List<ArticleOptions> businessArticles = <ArticleOptions>[
    // --> Features article
    ArticleOptions(
      icon: (Color? stateColor) {
        return Icon(
          Icons.local_shipping,
          color: stateColor,
        );
      },
      route: TWSARoutes.trucksArticle,
      title: 'Trucks',
    ),
    ArticleOptions(
      icon: (Color? stateColor) {
        return Icon(
          Icons.crop_16_9,
          color: stateColor,
        );
      },
      route: TWSARoutes.trailersArticle,
      title: 'Trailers',
    ),
    ArticleOptions(
      icon: (Color? stateColor) {
        return Icon(
          Icons.contact_emergency_rounded,
          color: stateColor,
        );
      },
      route: TWSARoutes.driversArticle,
      title: 'Drivers',
    ),
    ArticleOptions(
      icon: (Color? stateColor) {
        return Icon(
          Icons.location_on,
          color: stateColor,
        );
      },
      route: TWSARoutes.locationsArticle,
      title: 'Locations',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ArticleFrame(
      articlesOptions: businessArticles,
      actionsOptions: actionsOptions,
      currentRoute: currentRoute,
      article: article,
    );
  }
}
