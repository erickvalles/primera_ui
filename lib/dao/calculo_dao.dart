import 'package:floor/floor.dart';

import '../models/calculo.dart';

@dao
abstract class CalculoDao {
  @Query("SELECT * FROM Calculo order by id desc")
  Future<List<Calculo>> todosCalculos();

  @Query("SELECT * FROM Calculo WHERE id = :id")
  Stream<Calculo?> buscarCalculoPorId(int id);

  @insert
  Future<int> insertarCalculo(Calculo calculo);
}
