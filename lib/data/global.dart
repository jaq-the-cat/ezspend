import 'storage.dart';
import 'converter.dart';

class Global {
  static Storage? storage;
  static Converter? converter;

  static Future<bool> init() async {
    converter ??= await Converter.init();
    storage ??= await Storage.init();
    return true;
  }
}
