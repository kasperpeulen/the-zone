import 'package:the_zone/services/time_record_service.dart';
import 'package:the_zone/services/connection_service.dart';
import 'package:the_zone/services/auth_service.dart';
import 'package:the_zone/services/storage_service.dart';
import 'dart:html';
import 'package:angular2/angular2.dart';
import 'package:logging/logging.dart';
import 'logger_provider.dart';

List get appProviders => [
      TimeRecordService,
      ConnectionService,
      AuthService,
      StorageService,
      provide(AppMode, useValue: appMode),
      provide(AppName, useValue: appName),
      provide(Logger, useFactory: initLog, deps: [AppName, AppMode])
    ];

OpaqueToken AppName = const OpaqueToken("AppName");

String appName = "the_zone";

enum AppMode { production, develop }

AppMode appMode = window.location.host.contains('localhost')
    ? AppMode.develop
    : AppMode.production;
