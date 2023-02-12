import 'package:flutter/material.dart';
import '../data/global.dart';
import 'pick_from_list.dart';

class _SavePickerItem extends StatelessWidget {
  final String name;
  final void Function(String) onEdit;
  final void Function(String) onDelete;
  const _SavePickerItem(this.name, {
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            child: Text(name, style: const TextStyle(fontSize: 16)),
            onPressed: () { Navigator.of(context).pop(name); },
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () async {
                final value = await textFormDialog(context);
                if (value != null) {
                  onEdit(value);
                }
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                onDelete(name);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        )
      ]
    );
  }
}

class SaveDisplay extends StatelessWidget {
  final void Function(String name) updateCurrentSave;
  final void Function(String, String) renameSave;
  final void Function(String) deleteSave;

  const SaveDisplay({
    required this.updateCurrentSave,
    required this.renameSave,
    required this.deleteSave,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () async {
            final name = await pickFromList(context, Global.storage!.saves.toList(),
              itemBuilder: (context, name) => _SavePickerItem(name,
                onEdit: (newName) {
                  renameSave(name, newName);
                  Navigator.of(context).pop();
                },
                onDelete: (name) {
                  deleteSave(name);
                  Navigator.of(context).pop();
                }
              )
            );
            if (name != null) {
              updateCurrentSave(name);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.4),
              child: Text(Global.storage!.settings.currentSave,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20, color: Colors.white54)),
            )
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          color: Colors.white54,
          onPressed: () async {
            final name = await textFormDialog(context);
            if (name != null) {
              updateCurrentSave(name);
            }
          },
        ),
      ],
    );
  }
}

Future<String?> textFormDialog(BuildContext context) => showDialog<String>(context: context,
  builder: (context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: const Text("New Save"),
      content: TextFormField(
        controller: controller,
        decoration: const InputDecoration(border: OutlineInputBorder())
      ),
      actions: [
        TextButton(child: const Text("Cancel"), onPressed: () {
          Navigator.of(context).pop();
        }),
        TextButton(child: const Text("Create"), onPressed: () {
          Navigator.of(context).pop(controller.text);
        }),
      ],
    );
  }
);
