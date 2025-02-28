import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/character_details.dart';
import 'package:rick_and_morty/characters_list.dart';
import 'DeviceTypeAndOrientation.dart';
import 'characters_view_model.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Rick and Morty Characters'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceType = getDeviceTypeAndOrientation(context);

    return ChangeNotifierProvider<CharactersViewModel>(
      create: (BuildContext context) => CharactersViewModel(),
      child: Consumer<CharactersViewModel>(
        builder: (context, data, child) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: data.showSearchBar
                    ? TextField(
                        controller: data.searchBarController,
                    onChanged: (text) => data.onSearchChanged(text),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(

                            prefixIcon: IconButton(
                              icon: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Icon(Icons.close),
                              ),
                              color: Colors.white,
                              onPressed: () {
                                data.clearSearch();
                              }
                            ),
                            border: InputBorder.none,
                            hintText: 'Type character name',
                            hintStyle: TextStyle(color: Colors.white)))
                    : Text(title),
                actions: [
                  IconButton(onPressed: () => {}, icon: Icon(Icons.filter_alt)),
                  IconButton(
                    onPressed: () => data.showSearchBar = !data.showSearchBar,
                    icon: Icon(
                      Icons.search,
                    ),
                  ),
                ],
              ),
              body: (deviceType == DeviceType.phonePortrait ||
                      deviceType == DeviceType.tabletPortrait)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CharactersList())
                  : SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: size.width * 0.4, child: CharactersList()),
                          data.filteredCharactersList.isNotEmpty
                              ? SizedBox(
                                  child: CharacterDetails(
                                      data.selectedCharacter ??
                                          data.filteredCharactersList[0]))
                              : SizedBox(
                                  width: size.width * 0.6,
                                  child: SizedBox.shrink())
                        ],
                      ),
                    ));
        },
      ),
    );
  }
}
