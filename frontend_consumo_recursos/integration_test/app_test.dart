import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:frontend_consumo_recursos/main.dart';
import 'package:frontend_consumo_recursos/views/poliza_view.dart';
import '../test/fakes.dart'; // ruta relativa

void main() {
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
      await _launchApp(tester);

      await tester.enterText(find.byKey(const Key('propietarioField')), 'Ana');
      await tester.enterText(find.byKey(const Key('valorField')), '10000');
      await tester.tap(find.byKey(const Key('modelo_B')));
      await tester.tap(find.byKey(const Key('edad_23-55')));
      await tester.enterText(find.byKey(const Key('accidentesField')), '2');
      await tester.tap(find.byKey(const Key('calcularButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('costoTotalText')), findsOneWidget);
      expect(
        (find.byKey(const Key('costoTotalText')).evaluate().single.widget
                as Text)
            .data,
        isNot(r'$0.00'),
      );
    });

    testWidgets('Consulta y resumen de póliza', (tester) async {
      await _launchApp(tester);

      await tester.tap(find.text('Buscar'));
      await tester.pumpAndSettle();

      // Asegura que lista exista y primer ítem se muestra
      expect(find.byKey(const Key('usuariosList')), findsOneWidget);
      await tester.tap(find.byKey(const Key('usuarioItem_0')));
      await tester.pumpAndSettle();

      // Aquí mostrarías un detalle; por ahora validamos que siga en pantalla
      expect(find.byType(ListTile), findsWidgets);
    });
  });
}

// ---------- Helpers ----------
Future<void> _launchApp(WidgetTester tester, {bool logged = true}) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FakePolizaViewModel()),
        ChangeNotifierProvider(create: (_) => FakeLoginViewModel()),
      ],
      child: const MyApp(), // MyApp de main.dart
    ),
  );

  await tester.pumpAndSettle();

  if (logged) {
    // Simula login automático: navega directo a PolizaView
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FakePolizaViewModel(),
        child: const MaterialApp(home: PolizaView()),
      ),
    );
    await tester.pumpAndSettle();
  }
}
