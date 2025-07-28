class Poliza {
  final String propietario;
  final double valorAlquiler;
  final String modeloAuto;
  final String edadPropietario;
  final int accidentes;
  final double costoTotal;

  Poliza({
    required this.propietario,
    required this.valorAlquiler,
    required this.modeloAuto,
    required this.edadPropietario,
    required this.accidentes,
    required this.costoTotal,
  });

  factory Poliza.fromJson(Map<String, dynamic> json) {
    return Poliza(
      propietario: json['propietario'] as String,
      valorAlquiler: (json['valor'] as num).toDouble(),
      modeloAuto: json['modeloAuto'] as String,
      edadPropietario: json['edadPropietario'] as String,
      accidentes: json['accidentes'] as int,
      costoTotal: (json['costoTotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() =>
    {
      'propietario': propietario,
      'valor': valorAlquiler,
      'modeloAuto': modeloAuto,
      'edadPropietario': edadPropietario,
      'accidentes': accidentes,
      'costoTotal': costoTotal,
    };

}
