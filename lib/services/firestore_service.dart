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
        'child_name': '',
        'created_at': FieldValue.serverTimestamp(),
      });

      await _createProgressDocs(userRef);
    } else {
      await _createMissingProgressDocs(userRef);
    }
  }

  Future<void> _createProgressDocs(DocumentReference userRef) async {
final categories = ['alphabets', 'numbers', 'colors', 'shapes'];
    for (final category in categories) {
      await userRef.collection('progress').doc(category).set({
        'completed': 0,
        'total': 3,
      });
    }
  }

  Future<void> _createMissingProgressDocs(DocumentReference userRef) async {
    final categories = ['alphabets', 'numbers', 'colors', 'shapes', 'sounds'];

    for (final category in categories) {
      final docRef = userRef.collection('progress').doc(category);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set({
          'completed': 0,
          'total': 3,
        });
      }
    }
  }

  Future<bool> hasChildName() async {
    final doc = await _db.collection('users').doc(userId).get();
    final data = doc.data();

    if (data == null) return false;

    final name = data['child_name'] ?? '';
    return name.toString().trim().isNotEmpty;
  }

  Future<void> saveChildName(String name) async {
    await _db.collection('users').doc(userId).update({
      'child_name': name.trim(),
    });
  }

  Future<String> getChildName() async {
    final doc = await _db.collection('users').doc(userId).get();
    final data = doc.data();

    return data?['child_name'] ?? 'Learner';
  }

  Future<void> completeGame(String category) async {
    final progressRef = _db
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc(category);

    final doc = await progressRef.get();
    final data = doc.data();

    if (data == null) return;

    final int completed = data['completed'] ?? 0;
    final int total = data['total'] ?? 3;

    if (completed < total) {
      await progressRef.update({
        'completed': FieldValue.increment(1),
      });
    }
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
