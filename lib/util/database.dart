import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/calculo_dao.dart';
import '../models/calculo.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Calculo])
abstract class AppDatabase extends FloorDatabase {
  CalculoDao get calculoDao;
}
