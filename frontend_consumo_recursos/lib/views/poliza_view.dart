import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';
import 'usuarios_view.dart';

class PolizaView extends StatefulWidget {
  static const routeName = '/poliza';
  const PolizaView({super.key});

  @override
  State<PolizaView> createState() => _PolizaViewState();
}

class _PolizaViewState extends State<PolizaView> {
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _propietarioController = TextEditingController();

  @override
  void dispose() {
    _valorController.dispose();
    _accidentesController.dispose();
    _propietarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PolizaViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Póliza", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UsuariosView()),
            );
          }
        },
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Usuarios"),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInput("Propietario", _propietarioController, (val) {
              vm.propietario = val;
              vm.notifyListeners();
            }),
            const SizedBox(height: 12),
            _buildInput("Valor del seguro", _valorController, (val) {
              final number = double.tryParse(val) ?? 0;
              vm.valorAlquiler = number < 0 ? 0 : number;
              if (number < 0) _valorController.text = '0';
              vm.notifyListeners();
            }, keyboard: TextInputType.number),
            const SizedBox(height: 12),
            Text("Modelo de auto:", style: Theme.of(context).textTheme.titleMedium),
            for (var m in ['A', 'B', 'C'])
              _buildRadio("Modelo $m", m, vm.modeloAuto, (val) {
                vm.modeloAuto = val!;
                vm.notifyListeners();
              }),
            const SizedBox(height: 12),
            Text("Edad propietario:", style: Theme.of(context).textTheme.titleMedium),
            for (var e in ['18-23', '23-55', '55+'])
              _buildRadio(_textoEdad(e), e, vm.edadPropietario, (val) {
                vm.edadPropietario = val!;
                vm.notifyListeners();
              }),
            const SizedBox(height: 12),
            _buildInput("Número de accidentes", _accidentesController, (val) {
              final number = int.tryParse(val) ?? 0;
              vm.accidentes = number < 0 ? 0 : number;
              if (number < 0) _accidentesController.text = '0';
              vm.notifyListeners();
            }, keyboard: TextInputType.number),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal,
                ),
                onPressed: () async {
                  await vm.calcularPoliza();
                  _limpiarCampos();
                },
                child: const Text("CREAR PÓLIZA",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Costo total:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(width: 10),
                Text(
                  "\$${vm.costoTotal.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, Function(String) onChanged,
      {TextInputType? keyboard}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  Widget _buildRadio(String label, String value, String groupValue, Function(String?) onChanged) {
    return RadioListTile(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: Colors.teal,
    );
  }

  String _textoEdad(String rango) {
    switch (rango) {
      case '18-23':
        return 'Mayor igual a 18 y menor a 23';
      case '23-55':
        return 'Mayor igual a 23 y menor a 55';
      default:
        return 'Mayor igual 55';
    }
  }

  void _limpiarCampos() {
    _propietarioController.clear();
    _valorController.clear();
    _accidentesController.clear();
  }
}