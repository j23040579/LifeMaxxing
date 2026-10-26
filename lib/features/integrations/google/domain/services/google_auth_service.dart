import 'package:http/http.dart' as http;
import '../models/google_account_info.dart';

abstract class GoogleAuthService {
  /// Scopes required by LifeMaxxing with least-privilege principle
  static const List<String> scopes = [
    'email',
    'https://www.googleapis.com/auth/calendar.events',
    'https://www.googleapis.com/auth/tasks',
  ];

  Future<GoogleAccountInfo?> getCurrentUser();
  Future<GoogleAccountInfo> signIn();
  Future<void> signOut();
  Future<http.Client?> getAuthenticatedClient();
  Future<bool> isAuthorized();
}
