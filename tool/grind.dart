#!/usr/bin/env dart
import 'dart:io';
import 'dart:async';

import 'package:grinder/grinder.dart';
import 'package:dogma_codegen/build.dart';
import 'package:watcher/watcher.dart';
import 'package:git/git.dart';

void main(List<String> args) {
  grind(args);
}

@Task()
@Depends(analyze, testFormat)
void travis() {}

@DefaultTask()
@Depends(analyze, format)
void prePush() {}

@Task()
void analyze() {
  Analyzer.analyze(existingSourceDirs);
}

@Task('Apply dartfmt to all Dart source files')
void format() {
  DartFmt.format(existingSourceDirs);
}

@Task('Test dartfmt for all Dart source files')
void testFormat() {
  if (DartFmt.dryRun(existingSourceDirs)) {
    throw "dartfmt failure";
  }
}

@Task('Deploy to firebase')
void deploy() {
  Pub.build(directories: ['web']);
  run('firebase', arguments: ['deploy']);
}

@Task()
Future buildDogma() async {
  await build([],
      modelPath: 'lib/models',
      convertPath: 'lib/convert',
      mapper: false,
      unmodifiable: false);
}

@Task()
Future watchDogma() async {
  await for (var _ in new Watcher('lib/models').events) {
    await buildDogma();
  }
}

@Task()
Future createService() async {
  await for (var bytes in stdin) {
    String input = SYSTEM_ENCODING.decode(bytes).trim();
    new File('lib/services/${input}_service.dart')..writeAsStringSync('''
import 'package:angular2/core.dart';

@Injectable()
class ${input.split('_').map((s) => s[0].toUpperCase() + s.substring(1)).join('')}Service {}
    ''');
    await runGit(['add', '--all']);
  }
}

@Task()
Future<Null> createComponent() async {
  await stdin
      .map(SYSTEM_ENCODING.decode)
      .map((s) => s.trim())
      .forEach((component) async {
    new File('lib/components/$component.scss')..createSync();
    new File('lib/components/$component.html')..createSync();
    new File('lib/components/$component.dart')
      ..createSync()
      ..writeAsStringSync('''
import 'package:angular2/core.dart';

@Component(
    selector: '${component.replaceAll('_', '-')}',
    templateUrl: '$component.html',
    styleUrls: const ['$component.css']
)
class ${component.split('_').map((s) => s[0].toUpperCase() + s.substring(1)).join('')}Component {}
      ''');
    await runGit(['add', '--all']);
  });
}
