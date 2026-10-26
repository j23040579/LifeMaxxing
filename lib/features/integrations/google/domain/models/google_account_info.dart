/// Information about the connected Google account.
class GoogleAccountInfo {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isConnected;
  final DateTime? lastSyncTime;
  final List<String> authorizedScopes;

  const GoogleAccountInfo({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isConnected = true,
    this.lastSyncTime,
    this.authorizedScopes = const [],
  });

  const GoogleAccountInfo.disconnected()
      : id = '',
        email = '',
        displayName = null,
        photoUrl = null,
        isConnected = false,
        lastSyncTime = null,
        authorizedScopes = const [];

  GoogleAccountInfo copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isConnected,
    DateTime? lastSyncTime,
    List<String>? authorizedScopes,
  }) {
    return GoogleAccountInfo(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isConnected: isConnected ?? this.isConnected,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      authorizedScopes: authorizedScopes ?? this.authorizedScopes,
    );
  }
}
