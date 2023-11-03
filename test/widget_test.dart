import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ponta_tags/views/management_animal_screen.dart';

void main() {
  testWidgets('Test ManagementAnimalScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ManagementAnimalScreen()));

    // Teste: Verificar se o título da fazenda é exibido
    expect(find.text('FAZENDA'), findsOneWidget);

    // Teste: Verificar se o botão de edição da fazenda é exibido
    expect(find.byIcon(Icons.edit), findsOneWidget);

    // Simular um toque no botão de edição da fazenda
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();

    // Teste: Verificar se o diálogo de edição da fazenda é exibido
    expect(find.text('EDITAR FAZENDA'), findsOneWidget);

    // Teste: Verificar se o campo de entrada é exibido no diálogo de edição da fazenda
    expect(find.byType(TextField), findsOneWidget);

    // Simular a entrada de um novo nome da fazenda e pressionar o botão de salvar
    await tester.enterText(find.byType(TextField), 'Nova Fazenda');
    await tester.tap(find.text('ALTERAR'));
    await tester.pump();

    // Teste: Verificar se a fazenda foi alterada com sucesso
    expect(find.text('FAZENDA Nova Fazenda'), findsOneWidget);

    // Teste: Verificar se a lista de animais está vazia inicialmente
    expect(find.text('NENHUMA INFORMAÇÃO SALVA'), findsOneWidget);

    // Simular a adição de um novo animal
    await tester.tap(find.byIcon(Icons.add_circle));
    await tester.pump();

    // Teste: Verificar se o diálogo de adição de animal é exibido
    expect(find.text('CADASTRAR ANIMAL'), findsOneWidget);

    // Simular a entrada de uma tag de animal válida e pressionar o botão de salvar
    await tester.enterText(find.byType(TextField), '123456789012345');
    await tester.tap(find.text('SALVAR'));
    await tester.pump();

    // Teste: Verificar se o animal foi adicionado com sucesso à lista
    expect(find.text('123456789012345'), findsOneWidget);

    // Teste: Verificar se a lista de animais não está mais vazia
    expect(find.text('NENHUMA INFORMAÇÃO SALVA'), findsNothing);

    // Simular a edição de um animal existente
    await tester.tap(find.text('123456789012345'));
    await tester.pump();

    // Teste: Verificar se o diálogo de edição de animal é exibido
    expect(find.text('EDITAR ANIMAL'), findsOneWidget);

    // Simular a alteração da tag do animal
    await tester.enterText(find.byType(TextField), '987654321098765');
    await tester.tap(find.text('EDITAR'));
    await tester.pump();

    // Teste: Verificar se o animal foi editado com sucesso na lista
    expect(find.text('987654321098765'), findsOneWidget);
  });
}
