/// Clock callback used to make cache expiry testable.
typedef CacheClock = DateTime Function();

/// In-memory single-value cache with TTL and in-flight request deduplication.
final class TimedMemoryCache<T> {
  /// Time-to-live for stored values.
  final Duration ttl;

  /// Clock used to decide whether records are fresh.
  final CacheClock _now;

  /// Creates a single-value cache with [ttl].
  TimedMemoryCache({required this.ttl, CacheClock? now})
    : _now = now ?? DateTime.now;

  /// Stored value and timestamp.
  _CacheRecord<T>? _record;

  /// In-flight loader reused by concurrent callers.
  Future<T>? _inFlight;

  /// Returns the cached value if it exists and is still fresh.
  T? get value {
    final _CacheRecord<T>? record = _record;
    if (record == null || !_isFresh(record)) {
      return null;
    }

    return record.value;
  }

  /// Returns a fresh cached value or loads and stores one with [loader].
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

  /// Stores [value] using the current cache clock.
  void store(T value) {
    _record = _CacheRecord<T>(value: value, storedAt: _now());
  }

  /// Clears cached and in-flight state.
  void invalidate() {
    _record = null;
    _inFlight = null;
  }

  bool _isFresh(_CacheRecord<T> record) {
    return _now().difference(record.storedAt) <= ttl;
  }
}

/// In-memory keyed cache with TTL and per-key in-flight request deduplication.
final class TimedMemoryCacheMap<K, V> {
  /// Time-to-live for stored values.
  final Duration ttl;

  /// Clock used to decide whether keyed records are fresh.
  final CacheClock _now;

  /// Creates a keyed cache with [ttl].
  TimedMemoryCacheMap({required this.ttl, CacheClock? now})
    : _now = now ?? DateTime.now;

  /// Stored values by cache key.
  final Map<K, _CacheRecord<V>> _records = <K, _CacheRecord<V>>{};

  /// In-flight loaders by cache key.
  final Map<K, Future<V>> _inFlight = <K, Future<V>>{};

  /// Returns the fresh cached value for [key], if any.
  V? get(K key) {
    final _CacheRecord<V>? record = _records[key];
    if (record == null || !_isFresh(record)) {
      return null;
    }

    return record.value;
  }

  /// Returns a fresh cached value or loads one for [key].
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

  /// Stores [value] under [key].
  void store(K key, V value) {
    _records[key] = _CacheRecord<V>(value: value, storedAt: _now());
  }

  /// Clears cached and in-flight state for [key].
  void invalidate(K key) {
    _records.remove(key);
    _inFlight.remove(key);
  }

  /// Clears all cached and in-flight values.
  void invalidateAll() {
    _records.clear();
    _inFlight.clear();
  }

  bool _isFresh(_CacheRecord<V> record) {
    return _now().difference(record.storedAt) <= ttl;
  }
}

final class _CacheRecord<T> {
  /// Cached value.
  final T value;

  /// Timestamp when the value was stored.
  final DateTime storedAt;

  /// Creates a cache record.
  const _CacheRecord({required this.value, required this.storedAt});
}
