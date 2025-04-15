import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_swap/auth/data/data_source/auth_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_swap/auth/data/models/user_model.dart';

class AuthFirebase extends AuthDataSource {
  static CollectionReference<UserModel> getuserCollections() =>
      FirebaseFirestore.instance
          .collection('users')
          .withConverter<UserModel>(
            fromFirestore:
                (snapshot, _) => UserModel.fromJson(snapshot.data()!),
            toFirestore: (userModel, _) => userModel.toJson(),
          );
  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    UserModel user = UserModel(
      id: credential.user!.uid,
      name: name,
      email: email,
    );
    CollectionReference userCollection = getuserCollections();
    await userCollection.doc(user.id).set(user);
    return user;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    print('xxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('xxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

      CollectionReference<UserModel> userCollection = getuserCollections();
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      DocumentSnapshot<UserModel> documentSnapshot =
          await userCollection.doc(credential.user!.uid).get();
      print('xxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

      return documentSnapshot.data()!;
    } catch (e) {
      print(e);
      print('xxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
      throw Exception(e);
    }
  }

  @override
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> resetPassword(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
