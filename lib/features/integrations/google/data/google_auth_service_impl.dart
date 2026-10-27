import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../domain/models/google_account_info.dart';
import '../domain/services/google_auth_service.dart';

class GoogleAuthServiceImpl implements GoogleAuthService {
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage _secureStorage;
  GoogleSignInAccount? _currentUser;
  bool _initialized = false;

  GoogleAuthServiceImpl({
    GoogleSignIn? googleSignIn,
    FlutterSecureStorage? secureStorage,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      try {
        await _googleSignIn.initialize();
      } catch (_) {
        // May already be initialized in test or preceding run
      }
      _initialized = true;
    }
  }

  @override
  Future<GoogleAccountInfo?> getCurrentUser() async {
    await _ensureInitialized();
    final email = await _secureStorage.read(key: 'user_email');
    if (email == null) return null;

    final lastSyncStr = await _secureStorage.read(key: 'last_sync_time');
    DateTime? lastSync;
    if (lastSyncStr != null) {
      lastSync = DateTime.tryParse(lastSyncStr);
    }

    return GoogleAccountInfo(
      id: _currentUser?.id ?? 'user',
      email: email,
      displayName: _currentUser?.displayName ?? email,
      photoUrl: _currentUser?.photoUrl,
      isConnected: true,
      lastSyncTime: lastSync,
      authorizedScopes: GoogleAuthService.scopes,
    );
  }

  @override
  Future<GoogleAccountInfo> signIn() async {
    await _ensureInitialized();
    final account = await _googleSignIn.authenticate();
    _currentUser = account;

    await _secureStorage.write(
      key: 'user_email',
      value: account.email,
    );
    await _secureStorage.write(
      key: 'last_sync_time',
      value: DateTime.now().toIso8601String(),
    );

    return GoogleAccountInfo(
      id: account.id,
      email: account.email,
      displayName: account.displayName,
      photoUrl: account.photoUrl,
      isConnected: true,
      lastSyncTime: DateTime.now(),
      authorizedScopes: GoogleAuthService.scopes,
    );
  }

  @override
  Future<void> signOut() async {
    await _ensureInitialized();
    await _googleSignIn.signOut();
    _currentUser = null;
    await _secureStorage.delete(key: 'user_email');
    await _secureStorage.delete(key: 'last_sync_time');
  }

  @override
  Future<http.Client?> getAuthenticatedClient() async {
    await _ensureInitialized();
    final clientAuth =
        _currentUser?.authorizationClient ?? _googleSignIn.authorizationClient;
    final auth = await clientAuth.authorizeScopes(GoogleAuthService.scopes);
    return auth.authClient(scopes: GoogleAuthService.scopes);
  }

  @override
  Future<bool> isAuthorized() async {
    final email = await _secureStorage.read(key: 'user_email');
    return email != null;
  }
}
