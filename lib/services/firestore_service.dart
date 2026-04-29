import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }

    return user.uid;
  }

  Future<void> initializeUserProgress() async {
    final userRef = _db.collection('users').doc(userId);

    final userDoc = await userRef.get();

    if (!userDoc.exists) {
      await userRef.set({
        'name': 'Young Learner',
        'created_at': FieldValue.serverTimestamp(),
      });

      await userRef.collection('progress').doc('alphabets').set({
        'completed': 0,
        'total': 9,
        'stars': 0,
      });

      await userRef.collection('progress').doc('numbers').set({
        'completed': 0,
        'total': 9,
        'stars': 0,
      });

      await userRef.collection('progress').doc('colors').set({
        'completed': 0,
        'total': 9,
        'stars': 0,
      });

      await userRef.collection('progress').doc('shapes').set({
        'completed': 0,
        'total': 9,
        'stars': 0,
      });

      await userRef.collection('progress').doc('sounds').set({
        'completed': 0,
        'total': 9,
        'stars': 0,
      });
    }
  }

  Future<void> completeLesson(String category) async {
    final progressRef = _db
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(category);

    await progressRef.update({
      'completed': FieldValue.increment(1),
      'stars': FieldValue.increment(1),
    });
  }

  Future<Map<String, dynamic>> getCategoryProgress(String category) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(category)
        .get();

    return snapshot.data() ?? {};
  }
}