// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CalculoDao? _calculoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Calculo` (`id` INTEGER, `nombre` TEXT, `boxSize` REAL, `numeroAtomos` INTEGER, `tamHistograma` INTEGER, `nombreArchivo` TEXT, `dirSalida` TEXT, `salidaGdr` TEXT, `salidaCoord` TEXT, `salidaSk` TEXT, `salidaAngulos` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CalculoDao get calculoDao {
    return _calculoDaoInstance ??= _$CalculoDao(database, changeListener);
  }
}

class _$CalculoDao extends CalculoDao {
  _$CalculoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _calculoInsertionAdapter = InsertionAdapter(
            database,
            'Calculo',
            (Calculo item) => <String, Object?>{
                  'id': item.id,
                  'nombre': item.nombre,
                  'boxSize': item.boxSize,
                  'numeroAtomos': item.numeroAtomos,
                  'tamHistograma': item.tamHistograma,
                  'nombreArchivo': item.nombreArchivo,
                  'dirSalida': item.dirSalida,
                  'salidaGdr': item.salidaGdr,
                  'salidaCoord': item.salidaCoord,
                  'salidaSk': item.salidaSk,
                  'salidaAngulos': item.salidaAngulos
                },
            changeListener),
        _calculoUpdateAdapter = UpdateAdapter(
            database,
            'Calculo',
            ['id'],
            (Calculo item) => <String, Object?>{
                  'id': item.id,
                  'nombre': item.nombre,
                  'boxSize': item.boxSize,
                  'numeroAtomos': item.numeroAtomos,
                  'tamHistograma': item.tamHistograma,
                  'nombreArchivo': item.nombreArchivo,
                  'dirSalida': item.dirSalida,
                  'salidaGdr': item.salidaGdr,
                  'salidaCoord': item.salidaCoord,
                  'salidaSk': item.salidaSk,
                  'salidaAngulos': item.salidaAngulos
                },
            changeListener),
        _calculoDeletionAdapter = DeletionAdapter(
            database,
            'Calculo',
            ['id'],
            (Calculo item) => <String, Object?>{
                  'id': item.id,
                  'nombre': item.nombre,
                  'boxSize': item.boxSize,
                  'numeroAtomos': item.numeroAtomos,
                  'tamHistograma': item.tamHistograma,
                  'nombreArchivo': item.nombreArchivo,
                  'dirSalida': item.dirSalida,
                  'salidaGdr': item.salidaGdr,
                  'salidaCoord': item.salidaCoord,
                  'salidaSk': item.salidaSk,
                  'salidaAngulos': item.salidaAngulos
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Calculo> _calculoInsertionAdapter;

  final UpdateAdapter<Calculo> _calculoUpdateAdapter;

  final DeletionAdapter<Calculo> _calculoDeletionAdapter;

  @override
  Future<List<Calculo>> todosCalculos() async {
    return _queryAdapter.queryList('SELECT * FROM Calculo order by id desc',
        mapper: (Map<String, Object?> row) => Calculo(
            row['id'] as int?,
            row['nombre'] as String?,
            row['boxSize'] as double?,
            row['numeroAtomos'] as int?,
            row['tamHistograma'] as int?,
            row['nombreArchivo'] as String?,
            row['dirSalida'] as String?,
            row['salidaGdr'] as String?,
            row['salidaCoord'] as String?,
            row['salidaSk'] as String?,
            row['salidaAngulos'] as String?));
  }

  @override
  Stream<Calculo?> buscarCalculoPorId(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Calculo WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Calculo(
            row['id'] as int?,
            row['nombre'] as String?,
            row['boxSize'] as double?,
            row['numeroAtomos'] as int?,
            row['tamHistograma'] as int?,
            row['nombreArchivo'] as String?,
            row['dirSalida'] as String?,
            row['salidaGdr'] as String?,
            row['salidaCoord'] as String?,
            row['salidaSk'] as String?,
            row['salidaAngulos'] as String?),
        arguments: [id],
        queryableName: 'Calculo',
        isView: false);
  }

  @override
  Future<void> deleteAllCalculos() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Calculo');
  }

  @override
  Future<int> insertarCalculo(Calculo calculo) {
    return _calculoInsertionAdapter.insertAndReturnId(
        calculo, OnConflictStrategy.abort);
  }

  @override
  Future<int> actualizaCalculo(Calculo calculo) {
    return _calculoUpdateAdapter.updateAndReturnChangedRows(
        calculo, OnConflictStrategy.abort);
  }

  @override
  Future<int> borrarCalculo(Calculo calculo) {
    return _calculoDeletionAdapter.deleteAndReturnChangedRows(calculo);
  }
}
