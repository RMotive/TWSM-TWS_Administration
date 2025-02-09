import 'dart:convert';

import 'package:csm_view/csm_view.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tws_administration_view/core/router/twsa_routes.dart';
import 'package:tws_foundation_client/tws_foundation_client.dart';

/// Specifies a static service.
///
/// Works as a singleton service to manage everything related to the session local storage functions.
class SessionStorage {
  //* --> SINGLETON PATTER HANDLER <--
  static SessionStorage? _instance;
  // Avoid self instance
  static SessionStorage get i => _instance ??= SessionStorage._();

  /// Indicates the key reference for the specific session item in the storage.
  static const String _kSessionItemStoreKey = "session-privileges";

  /// Service to print advises in console.
  late final CSMAdvisor _advisor;

  /// Stores the current session that the manager works in.
  Session? _session;

  /// Current session.
  Session? get session => _session;

  /// Wheter the application context has an active session
  late bool _isSession;
  bool get isSession => _isSession;

  /// When the singleton is created it first will look if the browser already has a stored session.
  SessionStorage._() {
    _advisor = const CSMAdvisor('session-storage');
    _advisor.message('Starting engines for [SessionStorage]');
    String? sessionGather = localStorage.getItem(_kSessionItemStoreKey);
    if (sessionGather == null) {
      _session = null;
      _isSession = false;
      return;
    }

    JObject json = jsonDecode(sessionGather);
    _session = Session.des(json);
    _isSession = _evaluateExpiration(_session!.expiration);
  }

  void storeSession(Session session) {
    _session = session;
    _isSession = _evaluateExpiration(session.expiration);
    localStorage.setItem(_kSessionItemStoreKey, jsonEncode(session.encode()));
  }

  static bool _evaluateExpiration(DateTime expiration) {
    DateTime now = DateTime.now();
    DateTime expLocal = expiration.toLocal();

    return now.isBefore(expLocal);
  }

  String getTokenStrict() {
    if (isSession) return _session!.token;

    CSMRouter.i.drive(TWSARoutes.loginPage);
    throw 'Removing token storages and leading to landing page';
  }

  void clearSession() {
    localStorage.removeItem(_kSessionItemStoreKey);
    _session = null;
    _isSession = false;
  }
}
