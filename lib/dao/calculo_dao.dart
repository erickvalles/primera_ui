import 'package:floor/floor.dart';

import '../models/calculo.dart';

@dao
abstract class CalculoDao {
  @Query("SELECT * FROM Calculo")
  Future<List<Calculo>> todosCalculos();

  @Query("SELECT * FROM Calculo WHERE id = :id")
  Stream<Calculo?> buscarCalculoPorId(int id);

  @insert
  Future<void> insertarCalculo(Calculo calculo);
}
