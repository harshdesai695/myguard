import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  User? get currentUser => _firebaseAuth.currentUser;

  bool get isAuthenticated => currentUser != null;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> getIdToken({bool forceRefresh = false}) async {
    return currentUser?.getIdToken(forceRefresh);
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<ConfirmationResult> signInWithPhoneNumber(String phoneNumber) async {
    return _firebaseAuth.signInWithPhoneNumber(phoneNumber);
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    return _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
