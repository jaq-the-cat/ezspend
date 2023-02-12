import 'dart:convert';
import 'package:http/http.dart' as http;

class Converter {
  static const url = "https://api.freecurrencyapi.com/v1/latest?apikey=Y0oR9YdRRur7iP5sptKj5ZhQg8uoLElWyOvUnf5l";
  final Map<String, num> dollarRates;

  Converter(this.dollarRates);
  static Future<Converter> init() async {
    return Converter(await getRates());
  }

  static Future<Map<String, num>> getRates() async {
    /*final resp = await http.get(Uri.parse(url));*/
    /*if (resp.statusCode != 200) return null;*/
    /*final toDollars =  jsonDecode(resp.body)["data"];*/
    final toDollars = {
      "AUD": 1.441127,
      "BGN": 1.81939,
      "BRL": 5.29101,
      "CAD": 1.344937,
      "CHF": 0.9221,
      "CNY": 6.780708,
      "CZK": 22.07404,
      "DKK": 6.930311,
      "EUR": 0.931051,
      "GBP": 0.825351,
      "HKD": 7.84982,
      "HUF": 361.020429,
      "IDR": 15145.016537,
      "ILS": 3.495225,
      "INR": 82.533558,
      "ISK": 140.690161,
      "JPY": 131.520218,
      "KRW": 1264.901363,
      "MXN": 18.783734,
      "MYR": 4.314506,
      "NOK": 10.179779,
      "NZD": 1.580587,
      "PHP": 54.640058,
      "PLN": 4.427955,
      "RON": 4.554909,
      "RUB": 73.040129,
      "SEK": 10.343914,
      "SGD": 1.325447,
      "THB": 33.570044,
      "TRY": 18.83473,
      "USD": 1,
      "ZAR": 17.755632
    };
    return toDollars;
  }

  num? fromTo(String xCode, num x, String yCode) {
    final xToDollarRate = dollarRates[xCode];
    final yToDollarRate = dollarRates[yCode];
    if (xToDollarRate == null || yToDollarRate == null) {
      return null;
    }
    // convert X to dollars
    num dollars = x / xToDollarRate;
    // convert dollars to Y
    return dollars * yToDollarRate;
  }

  num? toDollars(String xCode, num x) {
    final xToDollarRate = dollarRates[xCode];
    if (xToDollarRate == null) {
      return null;
    }
    return x / xToDollarRate;
  }
}
