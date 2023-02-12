import 'package:flutter/material.dart';
import 'widgets/sum_viewer.dart';
import 'widgets/currency_input.dart';
import 'widgets/circle_btn.dart';
import 'widgets/save_display.dart';
import 'data/global.dart';


class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SaveDisplay(
                updateCurrentSave: (String name) {
                  setState(() {
                    Global.storage!.settings.currentSave = name;
                  });
                },
                renameSave: (oldName, newName) async {
                  await Global.storage!.rename(oldName, newName);
                  setState(() {});
                },
                deleteSave: (name) async {
                  await Global.storage!.delete(name);
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              SumViewer(Global.storage!.load(), updateDisplay: (display) {
                setState(() {
                  Global.storage!.settings.display = display;
                });
              }),
            ],
          ),
          const SizedBox(height: 15),
          CurrencyInput(Global.storage!.settings.input, controller,
            codeSelected: (newCode) {
              Global.storage!.settings.input = newCode;
            },
          codes: Global.converter!.dollarRates.keys),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleButton(Icons.add, onPressed: () async {
                final usd = Global.converter!.fromTo(Global.storage!.settings.input,
                  num.tryParse(controller.text) ?? 0, "USD") ?? 0;
                setState(() {
                  Global.storage!.add(usd);
                });
              }),
              const SizedBox(width: 15),
              CircleButton(Icons.remove, onPressed: () async {
                final parsed = num.tryParse(controller.text);
                if (parsed != null) {
                  final usd = Global.converter!.fromTo(Global.storage!.settings.input, parsed, "USD") ?? 0;
                  setState(() {
                    Global.storage!.add(-usd);
                  });
                }
              }),
              const SizedBox(width: 15),
              CircleButton(Icons.restore, onPressed: () async {
                final result = await showDialog(context: context, builder: (context) => AlertDialog(
                  content: const Text("Are you sure you want to clear all data on this file?"),
                  actions: [
                    TextButton(child: const Text("No"), onPressed: () { Navigator.of(context).pop(false); }),
                    TextButton(child: const Text("Yes"), onPressed: () { Navigator.of(context).pop(true); }),
                  ],
                ));
                if (result) {
                  setState(() {
                    Global.storage!.save(0);
                  });
                }
              }),
            ],
          ),
        ],
      ),
    );
  }
}

