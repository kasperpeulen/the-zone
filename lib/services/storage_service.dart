import 'dart:convert';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:the_zone/models/time_record.dart';
import 'package:firebase/firebase.dart';
import 'package:github/browser.dart';

@Injectable()
class StorageService {
  final Firebase _firebase;
  final Authentication _auth;

  StorageService(this._firebase, this._auth);

  void save(List<TimeRecord> recordings) {
    final authData = _firebase.getAuth();
    _firebase
        .child("users")
        .child(authData['uid'])
        .child('recordings')
        .set(JSON.decode(JSON.encode(recordings)));
  }

  Future<List<TimeRecord>> loadRecordings() async {
    if (_auth.isToken) {
      final authData = _firebase.getAuth();

      var snapshot = await _firebase
          .child("users")
          .child(authData['uid'])
          .child('recordings')
          .once("value");
      return snapshot.val()?.map((r) => new TimeRecord.fromJson(r))?.toList();
    }
    return null;
  }

  void reset() {
    final authData = _firebase.getAuth();
    _firebase.child("users").child(authData['uid']).child('recordings').set([]);
  }
}
