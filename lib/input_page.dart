import 'package:ezspend/widgets/load_future.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
              const SizedBox(width: 15),
              CircleButton(Icons.currency_exchange, onPressed: () async {
                final result = await showDialog<bool>(context: context, builder: (context) => ExchangeEdit(
                  updated: () { setState(() {}); },
                ));
                if (result == true) {
                  setState(() {});
                }
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class ExchangeEdit extends StatefulWidget {
  final VoidCallback? updated;
  const ExchangeEdit({super.key, this.updated});

  @override
  State<ExchangeEdit> createState() => _ExchangeEditState();
}

class _ExchangeEditState extends State<ExchangeEdit> {

  Widget rateItem(BuildContext context, String code, num value, void Function(String, num) onSubmit) {
    final controller = TextEditingController(text: value.toString());
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        SizedBox(
          width: 45,
          child: Text(code, style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
        ),
        Expanded(
          child: TextFormField(controller: controller, decoration: const InputDecoration(border: OutlineInputBorder())),
        ),
        IconButton(icon: const Icon(Icons.check), onPressed: () {
          final n = num.tryParse(controller.text);
          if (n != null) onSubmit(code, n);
        }),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 50,
              maxHeight: 250,
            ),
            child: ListView(
              shrinkWrap: true,
              children: List<Widget>.from(Global.converter!.dollarRates.entries
                .where((entry) => entry.key != "USD")
                .map((entry) {
                return rateItem(context, entry.key, entry.value, (code, value) {
                  setState(() {
                    Global.converter!.dollarRates[code] = value;
                  });
                  if (widget.updated != null) widget.updated!();
                });
              })),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: TextButton(
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Reload"),
                  ),
                  onPressed: () async {
                    showDialog(context: context, builder: (context) => Dialog(
                      child: SizedBox(
                        height: 75,
                        child: LoadingAnimationWidget.beat(
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      ),
                    ));
                    Global.converter!.refreshRates().whenComplete(() {
                      Navigator.of(context).pop();
                      setState(() {});
                    });
                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Close"),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
