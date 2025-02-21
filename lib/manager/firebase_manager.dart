import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseService firebaseManager = FirebaseManager();
abstract class FirebaseService {
  Future<FirebaseApp> init();
  FirebaseApp get app;
  FirebaseAuth get auth;
  FirebaseFirestore get firestoreInstance;
  FirebaseStorage get storageInstance;
}

class FirebaseManager extends FirebaseService {
  bool isInitialized = false;

  FirebaseApp? firebaseApp;
  FirebaseFirestore? _firestoreInstance;
  FirebaseStorage? _storageInstance;
  FirebaseAuth? _auth;

  @override
  Future<FirebaseApp> init() async {
    FirebaseApp app = Firebase.apps.firstOrNull ?? await Firebase.initializeApp();
    firebaseApp = app;
    _auth = FirebaseAuth.instanceFor(app: app);
    _firestoreInstance = FirebaseFirestore.instanceFor(app: app);
    _storageInstance = FirebaseStorage.instance;
    return app;
  }

  @override FirebaseApp get app => firebaseApp!;
  @override FirebaseAuth get auth => _auth!;
  @override FirebaseFirestore get firestoreInstance => _firestoreInstance!;
  @override FirebaseStorage get storageInstance => _storageInstance!;
}
