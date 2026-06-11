import 'package:flutter_test/flutter_test.dart';

import 'package:app_registro_att/main.dart';

void main() {
  testWidgets('App inicia na tela de listagem', (WidgetTester tester) async {
    await tester.pumpWidget(const AppRegistroAtt());
    expect(find.text('Registro de Atividades'), findsOneWidget);
  });
}
