import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/generated/l10n.dart';
import 'package:kanban_board/models/task.dart';
import 'package:kanban_board/models/user.dart';
import 'package:kanban_board/services/firestore_service.dart';
import 'package:kanban_board/utils/enums/columns.dart';
import 'package:kanban_board/widgets/participant_photo_widget.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    Key? key,
    required this.task,
    this.draggable = true,
  }) : super(key: key);
  final Task task;
  final bool draggable;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  int timeTaken = 0;
  @override
  Widget build(BuildContext context) {
    int presetTime = widget.task.isPaused
        ? widget.task.timeTaken ?? 0
        : widget.task.serverTimeStamp == null
            ? 0
            : Timestamp.now()
                .toDate()
                .difference((widget.task.serverTimeStamp!).toDate())
                .inSeconds;

    /// Can be set preset time. This case is "00:01.23".
    _stopWatchTimer.setPresetTime(mSec: presetTime * 1000);

    if (!widget.task.isPaused) {
      _stopWatchTimer.onStartTimer();
    }
    return LayoutBuilder(builder: (context, constraints) {
      return widget.draggable
          ? Draggable(
              data: widget.task,
              feedback: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Opacity(
                    opacity: 0.8,
                    child: _task(context),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.2,
                child: _task(context),
              ),
              child: _task(context),
            )
          : _task(context);
    });
  }

  Widget _task(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.12),
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).colorScheme.background,
      ),
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
                  widget.task.title.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.value,
                    builder: (context, snap) {
                      final value = snap.data!;
                      timeTaken = (value / 1000).round();
                      final displayTime = StopWatchTimer.getDisplayTime(
                        value,
                        hours: true,
                        milliSecond: false,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          displayTime,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
            child: Text(
              widget.task.notes.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<List<String>>(
                    future: _getParticipantsPhotoUrl(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.done &&
                              snapshot.data != null
                          ? ParticipantsPhotoWidget(
                              photoUrls: snapshot.data!,
                            )
                          : const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                            );
                    }),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: widget.task.column == columnName(Columns.done)
                      ? TextButton(
                          onPressed: () async {
                            FirestoreService().makeArchive(widget.task);
                          },
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  Colors.transparent)),
                          child: Text(S.of(context).makeArchive))
                      : IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: widget.task.isPaused
                              ? () async {
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(widget.task.id)
                                      .update({
                                    'isPaused': false,
                                    'serverTimeStamp':
                                        FieldValue.serverTimestamp()
                                  });
                                }
                              : () async {
                                  _stopWatchTimer.onStopTimer();
                                  _stopWatchTimer.clearPresetTime();

                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(widget.task.id)
                                      .update({
                                    'isPaused': true,
                                    'timeTaken': timeTaken
                                  });
                                },
                          icon: Icon(widget.task.isPaused
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<List<String>> _getParticipantsPhotoUrl() async {
    List<String> photoUrls = [];
    await Future.forEach(widget.task.users!, (String p) async {
      final doc = await FirestoreService().getUser(p);
      final participant = User.fromFirestore(doc);
      if (doc.exists) {
        photoUrls.add(participant.photoUrl!);
      }
    });
    return photoUrls;
  }
}
