import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/generated/l10n.dart';
import 'package:kanban_board/models/archived_task.dart';
import 'package:kanban_board/pages/archives_page/widgets/archive_widget.dart';
import 'package:kanban_board/pages/archives_page/widgets/export_widget.dart';
import 'package:kanban_board/services/firestore_service.dart';

class ArchivesPage extends StatelessWidget {
  const ArchivesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).archives),
        elevation: 0,
        actions: const [ExportWidget()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirestoreService().getArchivesSnapshot(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(S.of(context).somethingWentWrong);
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(S.of(context).loading);
              }
              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      return ArchiveWidget(
                        archivedTask: ArchivedTask.fromFirestore(
                            document as DocumentSnapshot<Map<String, dynamic>>),
                      );
                    })
                    .toList()
                    .cast(),
              );
            }),
      ),
    );
  }
}
