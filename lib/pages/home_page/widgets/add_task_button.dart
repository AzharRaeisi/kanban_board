import 'package:flutter/material.dart';
import 'package:kanban_board/generated/l10n.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: Text(S.of(context).addTask),
      onTap: onTap,
    );
  }
}
