import 'package:flutter/material.dart';

Future<T?> pickFromList<T>(BuildContext context, List<T> list, {Widget Function(BuildContext context, T item)? itemBuilder}) async {
  return showDialog<T>(context: context, builder: (context) {
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
              children: List<Widget>.from(list.map((item) => itemBuilder == null
                ? TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(item.toString(), style: const TextStyle(fontSize: 16))
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(item);
                  }
                )
                : itemBuilder(context, item),
                )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text("Cancel"),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
          ),
        ],
      ),
    );
  });
}
