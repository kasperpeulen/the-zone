import 'dart:convert';
import 'dart:async';

import 'package:angular2/core.dart';
import 'package:the_zone/models/time_record.dart';
import 'package:firebase/firebase.dart';
import 'package:the_zone/convert/dimension_convert.dart';

@Injectable()
class StorageService {
  final Firebase _firebase;

  StorageService(this._firebase);

  void save(List<TimeRecord> recordings) {
    final authData = _firebase.getAuth();
    _firebase
        .child("users")
        .child(authData['uid'])
        .child('recordings')
        .set(JSON.decode(JSON.encode(recordings)));
  }

  Future<List<TimeRecord>> loadRecordings() async {
    final authData = _firebase.getAuth();

    var snapshot = await _firebase
        .child("users")
        .child(authData['uid'])
        .child('recordings')
        .once("value");
    return snapshot.val().map((r) {
      if (r['endedAt'] != 'null') {
        return new TimeRecord.fromJson(r);
      } else {

        // TODO clean this up
        return new TimeRecord(
            dimension: decodeDimension(r['dimension']),
            startedAt: DateTime.parse(r['startedAt']));

      }
    }).toList();
  }
}
