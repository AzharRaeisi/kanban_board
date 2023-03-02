import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/generated/l10n.dart';
import 'package:kanban_board/models/user.dart';
import 'package:kanban_board/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          S.of(context).profile,
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                AuthService().signOut();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 120,
              backgroundImage: CachedNetworkImageProvider(user.photoUrl!),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ListTile(
                leading: const Icon(Icons.person_4_rounded),
                title: Text(user.name!),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.mail_rounded),
              title: Text(user.email!.isEmpty ? '--' : user.email!),
            ),
          ],
        ),
      ),
    );
  }
}
