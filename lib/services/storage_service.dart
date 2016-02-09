import 'dart:convert';

import 'dart:html' hide Event;
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart';
import 'package:github/browser.dart' hide Event;
import 'package:the_zone/models.dart';

@Injectable()
class StorageService {
  final Firebase _firebase;
  final Authentication _auth;
  List<TimeRecord> recordings = [];

  StorageService(this._firebase, this._auth) {
    if (_auth.isToken) {
      if (!window.navigator.onLine) {
        _loadOffline();
      }
      _fbRecordingsChild.onChildAdded.listen(_onChildAdded);
      _fbRecordingsChild.onChildChanged.listen(_onChildChanged);
      _fbRecordingsChild.onChildRemoved.listen(_onChildRemoved);
    }
  }

  Firebase get _fbRecordingsChild {
    final auth = _firebase.getAuth();
    return _firebase.child("users").child(auth['uid']).child('recordings');
  }

  void update(TimeRecord recording) {
    _fbRecordingsChild.child(recording.uid).set(recording.toJson());
  }

  void push(TimeRecord recording) {
    final ref = _fbRecordingsChild.child(recording.uid);
    ref.set(recording.toJson());
  }

  void reset() {
    _fbRecordingsChild.set({});
  }

  void _onChildAdded(Event e) {
    recordings.add(new TimeRecord.fromJson(e.snapshot.val()));
    _saveOffline();
  }

  void _onChildChanged(Event e) {
    final recording = new TimeRecord.fromJson(e.snapshot.val());
    recordings =
        recordings.map((r) => r.uid == recording.uid ? recording : r).toList();
    _saveOffline();
  }

  void _onChildRemoved(Event e) {
    final recording = new TimeRecord.fromJson(e.snapshot.val());
    recordings.removeWhere((r) => recording.uid == r.uid);
    _saveOffline();
  }

  void _saveOffline() {
    window.localStorage['recordings'] = JSON.encode(recordings);
  }

  void _loadOffline() {
    final store = window.localStorage['recordings'];
    if (store != null) {
      final rawRecordings = JSON.decode(store) as List<Map>;
      rawRecordings?.forEach((r) {
        push(new TimeRecord.fromJson(r));
      });
    }
  }
}
