import 'dart:convert';

import 'dart:html' hide Event;
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart';
import 'package:github/browser.dart' hide Event;
import 'package:the_zone/models.dart';
import 'package:the_zone/models/time_record.dart';
import 'dart:async';
import 'package:the_zone/services/connection_service.dart';
import 'package:logging/logging.dart';

@Injectable()
class StorageService {
  final Firebase _firebase;
  final Authentication _auth;
  final ConnectionService _connection;
  final Logger _log;

  StorageService(this._firebase, this._auth, this._connection, this._log) {
    if (_auth.isToken) {
      if (_connection.offLine) {
        _loadOffline();
        _log.info('Loading records from local storage...');
        loaded = new Future(() {});
      } else {
        _log.info('Internet connection detected...\n'
            'Attempting to load records from firebase...');
        _fbRecordingsChild.onChildAdded.listen(_onChildAdded);
        _fbRecordingsChild.onChildChanged.listen(_onChildChanged);
        _fbRecordingsChild.onChildRemoved.listen(_onChildRemoved);

        loaded = _connection.connectedToFB.firstWhere((b) {
          _log.info('Loading records from firebase...');
          return b == true;
        });
      }
    } else {
      _log.info('User is not logged in.');
      loaded = new Future(() {});
    }
  }

  List<TimeRecord> recordings = [];

  /// Returns when data is fetched from firebase.
  /// Or in offline mode, from localStorage.
  Future loaded;

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
