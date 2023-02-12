import 'package:flutter/material.dart';
import '../data/global.dart';
import 'pick_from_list.dart';

class CurrencySelector extends StatefulWidget {
  final String initialCode;
  final void Function(String currencyCode) onSelected;
  const CurrencySelector({required this.onSelected, required this.initialCode, super.key});

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  String? code;
  List<String> codes = Global.converter!.dollarRates.keys.toList();

  @override
  Widget build(BuildContext context) {
    code ??= widget.initialCode;
    return IconButton(
      iconSize: 30,
      onPressed: () async {
        final data = await pickFromList(context, codes);
        if (data != null) {
          setState(() {
            code = data;
            widget.onSelected(data);
          });
        }
      },
      icon: Text(code!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Theme.of(context).colorScheme.primary,
        )
      ),
    );
  }
}
