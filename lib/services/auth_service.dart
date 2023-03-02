import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kanban_board/models/user.dart' as u;
import 'package:kanban_board/services/firestore_service.dart';

class AuthService {
  
  final _auth = FirebaseAuth.instance;

  Future<void> googleSignIn() async {
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      Fluttertoast.showToast(msg: "Authentication failed!");
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // // Once signed in, return the UserCredential
    await _auth.signInWithCredential(credential);

    final firestoreService = FirestoreService();
    final doc = await firestoreService.getCurrentUserDoc();

    if (!doc.exists) {
      await firestoreService.setUser(u.User(
              name: googleUser.displayName,
              email: googleUser.email,
              photoUrl: googleUser.photoUrl,
              isAnonymous: false)
          .toFirestore());
    }
  }

  Future<void> signinAnonymously() async {
    await _auth.signInAnonymously();
  }

  Future<void> githubSignIn() async{
    
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
