import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kanban_board/generated/l10n.dart';
import 'package:kanban_board/models/task.dart';
import 'package:kanban_board/utils/enums/columns.dart';
import 'package:kanban_board/models/user.dart' as u;

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget(
      {Key? key, required this.column, required this.availableParticipants})
      : super(key: key);
  final Columns column;
  final List<u.User> availableParticipants;
  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _notesController.dispose();
  }

  List<String> selectedParticipants = [FirebaseAuth.instance.currentUser!.uid];

  void _onTap(bool selected, String userId) {
    if (selected) {
      setState(() {
        selectedParticipants.add(userId);
      });
    } else {
      setState(() {
        selectedParticipants.remove(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).addTask,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_titleController.text.isEmpty) {
                    Fluttertoast.showToast(msg: S.of(context).pleaseEnterTodo);
                    return;
                  }

                  final docRef = await FirebaseFirestore.instance
                      .collection('tasks')
                      .add(Task(
                              id: '',
                              title: _titleController.text,
                              createdOn: Timestamp.now(),
                              notes: _notesController.text,
                              users: selectedParticipants,
                              createdBy: FirebaseAuth.instance.currentUser!.uid,
                              column: columnName( widget.column),
                              completedOn: widget.column == Columns.done
                                  ? Timestamp.now()
                                  : null)
                          .toFirestore());

                  docRef.update({
                    'createdOn': FieldValue.serverTimestamp(),
                    if (widget.column == Columns.done)
                      'completedOn': FieldValue.serverTimestamp(),
                  });

                  Navigator.pop(context);
                },
                child: Text(
                  S.of(context).add,
                  style: const TextStyle(fontSize: 20.0),
                ),
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent)),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 25.0),
            child: TextFormField(
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: S.of(context).taskTitle,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return S.of(context).pleaseEnterTodo;
                }
                return null;
              },
              controller: _titleController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 25.0),
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: S.of(context).additionalNotes,
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              controller: _notesController,
              minLines: 3,
              maxLines: 5,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15.0),
            child: Text(S.of(context).addParticipants),
          ),
          SizedBox(
            height: 300,
            child: ListView(
                children: widget.availableParticipants
                    .map((p) => CheckboxListTile(
                          value: selectedParticipants.contains(p.id),
                          onChanged: (value) =>
                              value != null ? _onTap(value, p.id!) : () {},
                          secondary: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage:
                                  CachedNetworkImageProvider(p.photoUrl!),
                            ),
                          ),
                          title: Text(p.name!),
                        ))
                    .toList()),
          )
        ],
      ),
    );
  }
}
