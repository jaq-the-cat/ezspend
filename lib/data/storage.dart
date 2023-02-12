import 'package:shared_preferences/shared_preferences.dart';

String _saveName(String id) => id.substring(1, id.lastIndexOf('/'));

class Settings {
  static const _defaultSave = "default";
  late String _currentSave;
  String get currentSave => _currentSave;
  set currentSave(String? value) {
    if (value != null) {
      _currentSave = value;
      _set("currentSave", value);
    }
  }

  static const _defaultDisplay = "EUR";
  late String _display;
  String get display => _display;
  set display(String? value) {
    if (value != null) {
      _display = value;
      _set("display", value);
    }
  }

  static const _defaultInput = "USD";
  late String _input;
  String get input => _input;
  set input(String? value) {
    if (value != null) {
      _input = value;
      _set("input", value);
    }
  }

  Settings._(this._currentSave, this._display, this._input);
  static Future<Settings> init() async {
    final pref = await SharedPreferences.getInstance();
    final name = pref.getString("currentSave");
    late String currentSave;
    if (name == null) {
      currentSave = _defaultSave;
    } else {
      currentSave = name;
    }
    final display = pref.getString("display") ?? _defaultDisplay;
    final input = pref.getString("input") ?? _defaultInput;

    return Settings._(currentSave, display, input);
  }

  Future<void> _set(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }
}

class Storage {
  final SharedPreferences _pref;
  final Settings settings;
  Storage._(this.settings, this._pref);
  static Future<Storage> init() async {
    final pref = await SharedPreferences.getInstance();
    final settings = await Settings.init();
    return Storage._(settings, pref);
  }

  static String _key(String name) => "_$name/${name.hashCode}";

  Iterable<String> get saves {
    return _pref.getKeys()
      .where((key) => key.startsWith("_"))
      .map((id) => _saveName(id));
  }

  Future<void> save(num value, [String? name]) {
    return _pref.setDouble(_key(name ?? settings.currentSave), value.toDouble());
  }

  void saveWasRemoved(String name) {
    if (settings.currentSave == name) {
      final savesList = saves;
      if (savesList.isNotEmpty) {
        settings.currentSave = savesList.first;
      } else {
        settings.currentSave = Settings._defaultSave;
      }
    }
  }

  Future<void> delete(String name) async {
    await _pref.remove(_key(name));
    saveWasRemoved(name);
  }

  Future<void> rename(String oldName, String newName) async {
    final value = load(oldName);
    await _pref.remove(_key(oldName));
    await _pref.setDouble(_key(newName), value.toDouble());
    if (settings.currentSave == oldName) {
      settings.currentSave = newName;
    }
  }

  num load([String? name]) {
    return _pref.getDouble(_key(name ?? settings.currentSave)) ?? 0;
  }

  void add(num value, [String? name]) {
    num current = load(name);
    save(current + value, name);
  }
}
