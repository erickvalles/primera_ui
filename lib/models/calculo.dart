import 'package:floor/floor.dart';

@entity
class Calculo {
  @primaryKey
  int? id;
  String? nombre;
  double? boxSize;
  int? numeroAtomos;
  int? tamHistograma;
  String? nombreArchivo;
  String? dirSalida;
  String? salidaGdr;
  String? salidaCoord;
  String? salidaSk;
  String? salidaAngulos;

  Calculo(
      this.id,
      this.nombre,
      this.boxSize,
      this.numeroAtomos,
      this.tamHistograma,
      this.nombreArchivo,
      this.dirSalida,
      this.salidaGdr,
      this.salidaCoord,
      this.salidaSk,
      this.salidaAngulos);
}
