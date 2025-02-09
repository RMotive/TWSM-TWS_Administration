import 'package:csm_view/csm_view.dart';
import 'package:tws_administration_view/core/secrets/development_secrets.dart';
import 'package:tws_administration_view/data/services/sources.dart';
import 'package:tws_administration_view/data/storages/session_storage.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

class DevelopmentConfigurator {
  static Future<void> configure() async {
    await _configureAccount();
  }

  static Future<void> _configureAccount() async {
    SessionStorage sessionStorage = SessionStorage.i;
    if (sessionStorage.isSession) return;

    final MainResolver<Session> service = await Sources.foundationSource.security.authenticate(DevelopmentSecrets.credentials).timeout(4.seconds);
    Session privileges = await service.act(Session.des);
    sessionStorage.storeSession(privileges);
  }
}
