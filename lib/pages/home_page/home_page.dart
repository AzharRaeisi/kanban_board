import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanban_board/models/user.dart' as u;
import 'package:kanban_board/pages/home_page/widgets/kanban_column.dart';
import 'package:kanban_board/pages/profile_page.dart';
import 'package:kanban_board/services/firestore_service.dart';
import 'package:kanban_board/utils/constants/color_seed.dart';
import 'package:kanban_board/utils/enums/columns.dart';
import 'package:kanban_board/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage(
      {super.key,
      required this.handleColorSelect,
      required this.handleBrightnessChange,
      required this.themeMode});

  final VoidCallback handleBrightnessChange;
  final void Function(ColorSeed seed) handleColorSelect;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(
        handleBrightnessChange: handleBrightnessChange,
        handleColorSelect: handleColorSelect,
        themeMode: themeMode,
      ),
      appBar: AppBar(
        title: const Text('Kanban'),
        elevation: 0,
        actions: [
          FutureBuilder<u.User>(
              future: _getUserPhotoUrl(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePage(user: snapshot.data!)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data!.photoUrl!,
                                  ),
                                ),
                              ),
                              if (MediaQuery.of(context).size.width > 600)
                                Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  child: FittedBox(
                                      child: Text(snapshot.data!.name!)),
                                )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox();
              })
        ],
      ),
      body: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        itemCount: Columns.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return KanbanColumn(
            column: Columns.values[index],
          );
        },
      ),
    );
  }

  Future<u.User> _getUserPhotoUrl() async {
    final firestoreService = FirestoreService();

    final doc = await firestoreService.getCurrentUserDoc();

    if (!doc.exists && FirebaseAuth.instance.currentUser!.isAnonymous) {
      final guestUsers = await firestoreService.getGuestUsers();

      final newGuestUser = u.User(
          name: 'Guest User ' + (guestUsers.docs.length + 1).toString(),
          email: '',
          isAnonymous: true,
          photoUrl:
              'https://st4.depositphotos.com/4329009/19956/v/450/depositphotos_199564354-stock-illustration-creative-vector-illustration-default-avatar.jpg');

      await firestoreService.setUser(newGuestUser.toFirestore());

      return newGuestUser;
    }

    return u.User.fromFirestore(doc);
  }
}
