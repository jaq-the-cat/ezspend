import 'package:flutter/material.dart';
import 'currency_selector.dart';

class CurrencyInput extends StatelessWidget {
  final TextEditingController controller;
  final Iterable<String> codes;
  final void Function(String)? codeSelected;
  final String initialCode;
  const CurrencyInput(this.initialCode, this.controller, {required this.codes, this.codeSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: CurrencySelector(
          initialCode: initialCode,
          onSelected: (currencyCode) {
            if (codeSelected != null) {
              codeSelected!(currencyCode);
            }
          }),
        suffixIcon: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            controller.clear();
          }
        ),
        border: const OutlineInputBorder()
      ),
    keyboardType: const TextInputType.numberWithOptions(decimal: true)
  );
}
}
