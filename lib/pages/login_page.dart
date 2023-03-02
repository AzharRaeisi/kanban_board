import 'package:flutter/material.dart';
import 'package:kanban_board/generated/l10n.dart';
import 'package:kanban_board/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 120,
            child: Text(
              'Kanban Board',
              style: TextStyle(fontSize: 24, letterSpacing: 3),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: TextButton.icon(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  onPressed: () => AuthService().googleSignIn(),
                  icon: Image.asset(
                    'assets/logos/google.png',
                    width: 24,
                    height: 24,
                  ),
                  label:  Text(
                   S.of(context).signinAsGoogle,
                    style:const TextStyle(fontSize: 18),
                  ))),
           Text('----------     ${S.of(context).or}     ----------'),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  S.of(context).signInAs,
                  style: const TextStyle(fontSize: 18),
                ),
                TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () async {
                      await AuthService().signinAnonymously();
                    },
                    child:  Text(
                      S.of(context).guest,
                      style: const TextStyle(fontSize: 20),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
