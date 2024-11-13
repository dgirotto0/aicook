import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fluxo de autenticação do usuário atual
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(
          (User? user) => user != null
          ? AppUser(
          uid: user.uid, email: user.email, name: user.displayName)
          : null,
    );
  }

  // Método para obter o usuário atual
  User? get currentUser => _auth.currentUser;

  // Método assíncrono para obter o usuário atual
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  // Login com Google
  Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user == null) {
        throw Exception("Usuário não encontrado após login com Google");
      }
      print(user.uid);
      print(user.email);
      print(user.displayName);

      return AppUser(uid: user.uid, email: user.email, name: user.displayName);
    } catch (e) {
      print('Erro no login com Google: $e');
      return null;
    }
  }

  // Login com Apple
  Future<AppUser?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
      User? user = userCredential.user;

      if (user == null) {
        throw Exception("Usuário não encontrado após login com Apple");
      }

      return AppUser(uid: user.uid, email: user.email, name: user.displayName);
    } catch (e) {
      print('Erro no login com Apple: $e');
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Excluir conta
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } catch (e) {
      print('Erro ao excluir a conta: $e');
    }
  }
}
