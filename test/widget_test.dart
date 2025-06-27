import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:demo_project/main.dart';

void main() {
  testWidgets('Poster UI loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ShivPoster()));

    // Check if TextField for name input is present
    expect(find.byType(TextField), findsOneWidget);

    // Check if three ElevatedButtons are present
    expect(find.byType(ElevatedButton), findsNWidgets(3));

    // Check if default person icon is shown when no image is uploaded
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
