import 'dart:convert';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart';
import 'package:github/browser.dart';
import 'package:the_zone/models.dart';

@Injectable()
class StorageService {
  final Firebase _firebase;
  final Authentication _auth;

  StorageService(this._firebase, this._auth);

  Map _clone(data){
    return JSON.decode(JSON.encode(data));
  }

  void update(TimeRecord recording) {
    final auth = _firebase.getAuth();
    final data = _clone(recording);
    _firebase
        .child('users')
        .child(auth['uid'])
        .child('recordings')
        .child(recording.uid)
        .set(data);
  }

  void push(TimeRecord recording){
    final auth = _firebase.getAuth();
    final ref = _firebase
        .child('users')
        .child(auth['uid'])
        .child('recordings')
        .push();

    recording.uid = ref.key;
    ref.set(_clone(recording));
  }

  Future<List<TimeRecord>> getAll() async {
    if (_auth.isToken) {
      final authData = _firebase.getAuth();

      var snapshot = await _firebase
          .child("users")
          .child(authData['uid'])
          .child('recordings')
          .once("value");

      Map data = snapshot.val();
      return data?.keys?.map((k) => new TimeRecord.fromJson(data[k]))?.toList();
    }
    return null;
  }

  void reset() {
    final authData = _firebase.getAuth();
    _firebase.child("users").child(authData['uid']).child('recordings').set([]);
  }
}
