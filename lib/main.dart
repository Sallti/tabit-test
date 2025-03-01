import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'characters_view_model.dart';
import 'home_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<CharactersViewModel>(
        create: (context) => CharactersViewModel()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff82dcf8)),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Rick and Morty Characters'),
    );
  }
}
