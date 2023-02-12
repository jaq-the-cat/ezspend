import 'package:flutter/material.dart';
import '../data/global.dart';
import 'pick_from_list.dart';

class SumViewer extends StatefulWidget {
  final num usd;
  final void Function(String) updateDisplay;
  const SumViewer(this.usd, {required this.updateDisplay, super.key});

  @override
  State<SumViewer> createState() => SumViewerState();
}

class SumViewerState extends State<SumViewer> {
  num convert() => Global.converter!.fromTo("USD", widget.usd, Global.storage!.settings.display) ?? 0;

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () async {
        final data = await pickFromList(context, Global.converter!.dollarRates.keys.toList());
        if (data != null) {
          widget.updateDisplay(data);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text("${convert().toStringAsFixed(2)} ${Global.storage!.settings.display}",
          style: const TextStyle(fontSize: 30))
      ),
    );
  }
}
