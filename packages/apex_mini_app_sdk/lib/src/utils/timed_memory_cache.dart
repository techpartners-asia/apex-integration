typedef CacheClock = DateTime Function();

final class TimedMemoryCache<T> {
  final Duration ttl;
  final CacheClock _now;

  TimedMemoryCache({required this.ttl, CacheClock? now})
    : _now = now ?? DateTime.now;

  _CacheRecord<T>? _record;
  Future<T>? _inFlight;

  T? get value {
    final _CacheRecord<T>? record = _record;
    if (record == null || !_isFresh(record)) {
      return null;
    }

    return record.value;
  }

  Future<T> getOrLoad(
    Future<T> Function() loader, {
    bool forceRefresh = false,
  }) async {
    final T? cached = !forceRefresh ? value : null;
    if (cached != null) {
      return cached;
    }

    if (!forceRefresh) {
      final Future<T>? inFlight = _inFlight;
      if (inFlight != null) {
        return inFlight;
      }
    }

    final Future<T> load = loader();
    _inFlight = load;

    try {
      final T next = await load;
      store(next);
      return next;
    } finally {
      if (identical(_inFlight, load)) {
        _inFlight = null;
      }
    }
  }

  void store(T value) {
    _record = _CacheRecord<T>(value: value, storedAt: _now());
  }

  void invalidate() {
    _record = null;
    _inFlight = null;
  }

  bool _isFresh(_CacheRecord<T> record) {
    return _now().difference(record.storedAt) <= ttl;
  }
}

final class TimedMemoryCacheMap<K, V> {
  final Duration ttl;
  final CacheClock _now;

  TimedMemoryCacheMap({required this.ttl, CacheClock? now})
    : _now = now ?? DateTime.now;

  final Map<K, _CacheRecord<V>> _records = <K, _CacheRecord<V>>{};
  final Map<K, Future<V>> _inFlight = <K, Future<V>>{};

  V? get(K key) {
    final _CacheRecord<V>? record = _records[key];
    if (record == null || !_isFresh(record)) {
      return null;
    }

    return record.value;
  }

  Future<V> getOrLoad(
    K key,
    Future<V> Function() loader, {
    bool forceRefresh = false,
  }) async {
    final V? cached = !forceRefresh ? get(key) : null;
    if (cached != null) {
      return cached;
    }

    if (!forceRefresh) {
      final Future<V>? inFlight = _inFlight[key];
      if (inFlight != null) {
        return inFlight;
      }
    }

    final Future<V> load = loader();
    _inFlight[key] = load;

    try {
      final V next = await load;
      store(key, next);
      return next;
    } finally {
      if (identical(_inFlight[key], load)) {
        _inFlight.remove(key);
      }
    }
  }

  void store(K key, V value) {
    _records[key] = _CacheRecord<V>(value: value, storedAt: _now());
  }

  void invalidate(K key) {
    _records.remove(key);
    _inFlight.remove(key);
  }

  void invalidateAll() {
    _records.clear();
    _inFlight.clear();
  }

  bool _isFresh(_CacheRecord<V> record) {
    return _now().difference(record.storedAt) <= ttl;
  }
}

final class _CacheRecord<T> {
  final T value;
  final DateTime storedAt;

  const _CacheRecord({required this.value, required this.storedAt});
}
