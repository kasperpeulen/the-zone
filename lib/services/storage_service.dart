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
      _recordingsChild.onChildAdded.listen(_onChildAdded);
      _recordingsChild.onChildChanged.listen(_onChildChanged);
      _recordingsChild.onChildRemoved.listen(_onChildRemoved);
    }
  }

  Firebase get _recordingsChild {
    final auth = _firebase.getAuth();
    return _firebase.child("users").child(auth['uid']).child('recordings');
  }

  void _onChildAdded(Event e) {
    recordings.add(new TimeRecord.fromJson(e.snapshot.val()));
  }

  void _onChildChanged(Event e) {
    final recording = new TimeRecord.fromJson(e.snapshot.val());
    recordings =
        recordings.map((r) => r.uid == recording.uid ? recording : r).toList();
  }

  void _onChildRemoved(Event e) {
    final recording = new TimeRecord.fromJson(e.snapshot.val());
    recordings.removeWhere((r) => recording.uid == r.uid);
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
    final ref = _recordingsChild.push();
    recording.uid = ref.key;
    ref.set(recording.toJson());
  }

  void reset() {
    _recordingsChild.set([]);
  }
}
