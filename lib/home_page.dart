import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty/status_filter.dart';

import 'DeviceTypeAndOrientation.dart';
import 'character_details.dart';
import 'characters_list.dart';
import 'characters_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceType = getDeviceTypeAndOrientation(context);

    return Consumer<CharactersViewModel>(
        builder: (context, charactersViewModel, child) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: charactersViewModel.showSearchBar
                ? TextField(
                    controller: charactersViewModel.searchBarController,
                    onChanged: (text) =>
                        charactersViewModel.onSearchChanged(text),
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
                              charactersViewModel.clearSearch();
                            }),
                        border: InputBorder.none,
                        hintText: 'Type character name',
                        hintStyle: TextStyle(color: Colors.white)))
                : Text(title),
            actions: [
              IconButton(
                  onPressed: () =>
                      _showAlertDialog(context, charactersViewModel),
                  icon: Icon(Icons.filter_alt)),
              IconButton(
                onPressed: () => charactersViewModel.showSearchBar =
                    !charactersViewModel.showSearchBar,
                icon: Icon(
                  Icons.search,
                ),
              ),
            ],
          ),
          body: charactersViewModel.errorMessage != null &&
                  charactersViewModel.errorMessage!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                        Text(
                          charactersViewModel.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 21),
                        ),
                      ],
                    ),
                  ),
                )
              : (charactersViewModel.errorMessage != null &&
                      charactersViewModel.errorMessage!.isNotEmpty)
                  ? Center(child: Text(charactersViewModel.errorMessage ?? ''))
                  : (deviceType == DeviceType.phonePortrait ||
                          deviceType == DeviceType.tabletPortrait)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CharactersList())
                      : SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: size.width * 0.4,
                                  child: CharactersList()),
                              charactersViewModel
                                      .filteredCharactersList.isNotEmpty
                                  ? SizedBox(
                                      child: CharacterDetails(
                                          charactersViewModel
                                                  .selectedCharacter ??
                                              charactersViewModel
                                                  .filteredCharactersList[0]))
                                  : SizedBox(
                                      width: size.width * 0.6,
                                      child: SizedBox.shrink())
                            ],
                          ),
                        ));
    });
  }

  _showAlertDialog(BuildContext context, CharactersViewModel viewModel) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter characters by status'),
          content: StatusFilter(),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                viewModel.startFilter();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Clear'),
              onPressed: () {
                viewModel.clearStatusFilter();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
