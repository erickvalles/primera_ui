import 'package:floor/floor.dart';

@entity
class Calculo {
  @primaryKey
  final int id;
  final String nombre;
  final double boxSize;
  final int numeroAtomos;
  final int tamHistograma;
  final String nombreArchivo;
  final String dirSalida;

  Calculo(this.id, this.nombre, this.boxSize, this.numeroAtomos,
      this.tamHistograma, this.nombreArchivo, this.dirSalida);
}
