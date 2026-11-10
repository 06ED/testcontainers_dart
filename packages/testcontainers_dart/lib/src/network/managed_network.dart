import 'package:docker_engine/docker_engine.dart';

/// A bridge network owned by one provider. Remove its containers before removal.
class ManagedNetwork({
  required final Docker _api,
  required final Object _owner,
  required final String id,
  required final String name,
}) {
  Future<void>? _termination;

  /// Used by the provider before any Docker operation.
  void checkOwner(Object owner) {
    if (!identical(owner, _owner)) {
      throw StateError('Network belongs to a different DockerProvider');
    }
    if (_termination != null) {
      throw StateError('Network is being removed or has been removed');
    }
  }

  Future<void> terminate() => _termination ??= _remove();

  Future<void> _remove() async {
    try {
      checkResponse(await _api.networksIdDelete(id: id), allowed: {404});
    } catch (_) {
      _termination = null;
      rethrow;
    }
  }
}
