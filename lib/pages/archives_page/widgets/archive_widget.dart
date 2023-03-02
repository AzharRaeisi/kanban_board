import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/generated/l10n.dart';
import 'package:kanban_board/models/archived_task.dart';
import 'package:kanban_board/models/user.dart';
import 'package:kanban_board/services/firestore_service.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ArchiveWidget extends StatelessWidget {
  const ArchiveWidget({Key? key, required this.archivedTask}) : super(key: key);
  final ArchivedTask archivedTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.12),
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      padding: const EdgeInsets.all(3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  archivedTask.title.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    StopWatchTimer.getDisplayTime(
                      archivedTask.timeTaken ?? 0,
                      hours: true,
                      milliSecond: false,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              archivedTask.notes.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('${S.of(context).CreatedOn}: '),
                Text(archivedTask.createdOn!.toDate().toLocal().toString()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('${S.of(context).completedOn}: '),
                Text(archivedTask.completedOn!.toDate().toLocal().toString()),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: FutureBuilder<List<User>>(
                  future: _getParticipants(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.done &&
                              snapshot.data != null
                          ? Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                title: Text(
                                  '${S.of(context).participants} (${snapshot.data!.length})',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: snapshot.data!
                                    .map((p) => ListTile(
                                          trailing: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            child: CircleAvatar(
                                              radius: 18,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      p.photoUrl!),
                                            ),
                                          ),
                                          title: Text(p.name!),
                                        ))
                                    .toList(),
                              ),
                            )
                          : const SizedBox()))
        ],
      ),
    );
  }

  Future<List<User>> _getParticipants() async {
    List<User> participants = [];
    await Future.forEach(archivedTask.users!, (String p) async {
      final doc = await FirestoreService().getUser(p);
      final participant = User.fromFirestore(doc);
      if (doc.exists) {
        participants.add(participant);
      }
    });
    return participants;
  }
}
