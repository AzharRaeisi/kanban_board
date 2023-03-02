import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/generated/l10n.dart';
import 'package:kanban_board/models/task.dart';
import 'package:kanban_board/pages/home_page/widgets/add_task_widget.dart';
import 'package:kanban_board/services/firestore_service.dart';
import 'package:kanban_board/utils/enums/columns.dart';
import 'package:kanban_board/pages/home_page/widgets/kanban_column_card.dart';
import 'package:kanban_board/widgets/task_widget.dart';
import 'package:kanban_board/models/user.dart' as u;

class KanbanColumn extends StatelessWidget {
  const KanbanColumn({Key? key, required this.column}) : super(key: key);
  final Columns column;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        KanbanColumnCard(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ListTile(
                    title: Text(
                      columnNameLocalized(context, column).toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    horizontalTitleGap: 0,
                    contentPadding: EdgeInsets.zero,
                    trailing: const Icon(Icons.add_circle_rounded),
                    onTap: () async {
                      final querySnapshot =
                          await FirestoreService().getAvailableUsers();
                      List<u.User> availableParticipants = [];
                      for (var doc in querySnapshot.docs) {
                        if (doc.id != FirebaseAuth.instance.currentUser!.uid) {
                          availableParticipants.add(u.User.fromFirestore(doc));
                        }
                      }
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        clipBehavior: Clip.hardEdge,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        builder: (context) => AddTaskWidget(
                          column: column,
                          availableParticipants: availableParticipants,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirestoreService().getTasks(column),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(S.of(context).somethingWentWrong);
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(S.of(context).loading);
                        }
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                                return TaskWidget(
                                  task: Task.fromFirestore(document
                                      as DocumentSnapshot<
                                          Map<String, dynamic>>),
                                );
                              })
                              .toList()
                              .cast(),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: DragTarget<Task>(
            onWillAccept: (data) {
              return true;
            },
            onLeave: (data) {},
            onAccept: (data) {
              FirestoreService().updateTask(data.id, column);
            },
            builder: (context, accept, reject) {
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
