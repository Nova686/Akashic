import 'dart:async';
import 'dart:collection';

sealed class SearchOutcome<T> {
  const SearchOutcome();
}

class SearchCleared<T> extends SearchOutcome<T> {
  const SearchCleared();
}

class SearchStarted<T> extends SearchOutcome<T> {
  const SearchStarted();
}

class SearchFinished<T> extends SearchOutcome<T> {
  const SearchFinished(this.results);

  final List<T> results;
}

class DebouncedSearch<T> {
  DebouncedSearch(
    this._search, {
    required this._onOutcome,
    this._delay = defaultDelay,
    this._minimumLength = defaultMinimumLength,
    this._rememberedQueries = 20,
  });

  static const Duration defaultDelay = Duration(milliseconds: 500);
  static const int defaultMinimumLength = 3;

  final Future<List<T>> Function(String query) _search;
  final void Function(SearchOutcome<T> outcome) _onOutcome;
  final Duration _delay;
  final int _minimumLength;
  final int _rememberedQueries;
  final LinkedHashMap<String, List<T>> _remembered = LinkedHashMap();
  Timer? _timer;
  int _generation = 0;
  String? _currentKey;
  bool _isClosed = false;

  String _keyOf(String query) => query.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  void request(String query) {
    if (_isClosed) {
      return;
    }
    final key = _keyOf(query);
    if (key == _currentKey) {
      return;
    }
    _timer?.cancel();
    _currentKey = key;
    final generation = ++_generation;
    if (key.length < _minimumLength) {
      _onOutcome(SearchCleared<T>());
      return;
    }
    final remembered = _remembered[key];
    if (remembered != null) {
      _onOutcome(SearchFinished<T>(remembered));
      return;
    }
    _timer = Timer(_delay, () => _run(query.trim(), key, generation));
  }

  void cancel() {
    _timer?.cancel();
    _generation++;
    _currentKey = null;
  }

  Future<void> _run(String query, String key, int generation) async {
    if (_isClosed || generation != _generation) {
      return;
    }
    _onOutcome(SearchStarted<T>());
    final results = await _search(query);
    if (_isClosed || generation != _generation) {
      return;
    }
    _remembered.remove(key);
    _remembered[key] = results;
    while (_remembered.length > _rememberedQueries) {
      _remembered.remove(_remembered.keys.first);
    }
    _onOutcome(SearchFinished<T>(results));
  }

  void close() {
    _isClosed = true;
    _timer?.cancel();
  }
}
