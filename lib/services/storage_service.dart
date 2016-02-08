import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart';
import 'package:github/browser.dart';
import 'package:the_zone/models.dart';

@Injectable()
class StorageService {
  final Firebase _firebase;
  final Authentication _auth;
  List<TimeRecord> recordings = [];

  StorageService(this._firebase, this._auth) {
    if(_auth.isToken) {
      _onChildAdded();
      _onChildChanged();
      _onChildRemoved();
    }
  }

  Firebase _recordingsChild() {
    final auth = _firebase.getAuth();
    return _firebase.child("users").child(auth['uid']).child('recordings');
  }

  void _onChildAdded() {
    _recordingsChild().onChildAdded.listen((e) {
      recordings.add(new TimeRecord.fromJson(e.snapshot.val()));
    });
  }

  void _onChildChanged() {
    _recordingsChild().onChildChanged.listen((e) {
      final recording = new TimeRecord.fromJson(e.snapshot.val());
      recordings = recordings.map((r) => r.uid == recording.uid ? recording : r);
    });
  }

  void _onChildRemoved() {
    _recordingsChild().onChildRemoved.listen((e) {
      final recording = new TimeRecord.fromJson(e.snapshot.val());
      recordings.removeWhere((r) => recording.uid == r.uid);
    });
  }

  void update(TimeRecord recording) {
    final auth = _firebase.getAuth();
    _firebase
        .child('users')
        .child(auth['uid'])
        .child('recordings')
        .child(recording.uid)
        .set(recording.toJson());
  }

  void push(TimeRecord recording) {
    final auth = _firebase.getAuth();
    final ref =
        _firebase.child('users').child(auth['uid']).child('recordings').push();

    recording.uid = ref.key;
    ref.set(recording.toJson());
  }

  void reset(){
    _recordingsChild().set([]);
  }
}
