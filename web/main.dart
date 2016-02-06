import 'package:angular2/bootstrap.dart';
import 'package:the_zone/components/body.dart';
import 'package:the_zone/services/time_record_service.dart';

void main() {
  bootstrap(BodyComponent, [TimeRecordService]);
}
