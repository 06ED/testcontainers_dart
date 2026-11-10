/// Credentials for one registry, never included in container configuration.
class RegistryCredentials {
  new({required String username, required String password})
    : _username = username,
      _password = password,
      _identityToken = null {
    if (username.isEmpty || username.contains(':') || password.isEmpty) {
      throw ArgumentError(
        'Registry username and password must be nonempty; '
        'username must not contain a colon',
      );
    }
  }

  new identityToken(String token)
    : _username = null,
      _password = null,
      _identityToken = token {
    if (token.isEmpty) throw ArgumentError('Registry token must be nonempty');
  }

  final String? _username;
  final String? _password;
  final String? _identityToken;

  /// Docker Engine authentication payload. Contains secrets; do not log it.
  Map<String, String> toJson(String serverAddress) => {
    if (_identityToken != null)
      'identitytoken': _identityToken
    else ...{
      'username': _username!,
      'password': _password!,
    },
    'serveraddress': serverAddress,
  };

  @override
  String toString() => 'RegistryCredentials(<redacted>)';
}

/// Deliberately excludes source data and underlying errors containing secrets.
class RegistryAuthException(final String message) implements Exception {
  @override
  String toString() => 'RegistryAuthException: $message';
}
