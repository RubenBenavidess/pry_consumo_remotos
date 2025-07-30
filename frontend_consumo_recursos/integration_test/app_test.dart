import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend_consumo_recursos/main.dart';
import 'package:frontend_consumo_recursos/views/login_view.dart';
import 'package:frontend_consumo_recursos/views/poliza_view.dart';
import 'package:frontend_consumo_recursos/viewmodels/poliza_viewmodel.dart';
import 'package:frontend_consumo_recursos/viewmodels/login_viewmodel.dart';
import 'package:frontend_consumo_recursos/views/usuarios_view.dart';
import '../test/fakes.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App integration', () {
    testWidgets('Login correcto', (tester) async {
      await _launchApp(tester, logged: false);

      await tester.enterText(find.byKey(const Key('userField')), 'demo');
      await tester.enterText(find.byKey(const Key('passField')), '1234');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.byType(PolizaView), findsOneWidget);
    });

    testWidgets('Login incorrecto', (tester) async {
      await _launchApp(tester, logged: false);

      await tester.enterText(find.byKey(const Key('userField')), 'bad');
      await tester.enterText(find.byKey(const Key('passField')), 'wrong');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      expect(find.text('Credenciales inválidas'), findsOneWidget);
    });

    testWidgets('Registro + cálculo de póliza', (tester) async {
      await _launchApp(tester, logged: true);

      final context = tester.element(find.byType(PolizaView));
      final vm = Provider.of<PolizaViewModel>(context, listen: false);

      // Verificar que estamos en PolizaView
      expect(find.byType(PolizaView), findsOneWidget);

      // Llenar formulario
      await tester.enterText(find.byKey(const Key('propietarioField')), 'Ana');
      await tester.pump();

      await tester.enterText(find.byKey(const Key('valorField')), '10000');
      await tester.pump();

      // Debug: verificar valores
      debugPrint('Propietario: ${vm.propietario}');
      debugPrint('Valor alquiler: ${vm.valorAlquiler}');

      // Hacer scroll y seleccionar opciones
      await tester.ensureVisible(find.byKey(const Key('modelo_B')));
      await tester.tap(find.byKey(const Key('modelo_B')));
      await tester.pump();

      await tester.ensureVisible(find.byKey(const Key('edad_23-55')));
      await tester.tap(find.byKey(const Key('edad_23-55')));
      await tester.pump();

      await tester.ensureVisible(find.byKey(const Key('accidentesField')));
      await tester.enterText(find.byKey(const Key('accidentesField')), '2');
      await tester.pump();

      // Debug: verificar todos los valores antes de calcular
      debugPrint('Modelo: ${vm.modeloAuto}');
      debugPrint('Edad: ${vm.edadPropietario}');
      debugPrint('Accidentes: ${vm.accidentes}');

      // Scroll hasta el botón calcular y hacer tap
      await tester.ensureVisible(find.byKey(const Key('calcularButton')));
      await tester.tap(find.byKey(const Key('calcularButton')));

      // Esperar el cálculo
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      debugPrint('Costo total después del cálculo: ${vm.costoTotal}');

      await tester.ensureVisible(find.byKey(const Key('costoTotalText')));
      await tester.pump();

      expect(find.byKey(const Key('costoTotalText')), findsOneWidget);
      final costoWidget = tester.widget<Text>(
        find.byKey(const Key('costoTotalText')),
      );
      debugPrint('Texto del widget: ${costoWidget.data}');

      expect(costoWidget.data, isNot(r'$0.00'));
    });

    testWidgets('Consulta y resumen de póliza', (tester) async {
      await _launchApp(tester, logged: true);

      await tester.tap(find.text('Usuarios'));
      await tester.pumpAndSettle();

      expect(find.byType(UsuariosView), findsOneWidget);
      expect(find.byKey(const Key('usuariosList')), findsOneWidget);

      await tester.tap(find.byKey(const Key('usuarioItem_0')));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(3));
    });
  });
}

// Helper actualizado con soporte para login
Future<void> _launchApp(WidgetTester tester, {bool logged = true}) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PolizaViewModel>(
          create: (_) => FakePolizaViewModel(),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create: (_) => FakeLoginViewModel(),
        ),
      ],
      child: MaterialApp(
        home: logged ? const PolizaView() : const LoginView(),
        routes: {
          '/login': (context) => const LoginView(),
          '/poliza': (context) => const PolizaView(),
          '/usuarios': (context) => const UsuariosView(),
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}
