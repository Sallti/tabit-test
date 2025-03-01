import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rick_and_morty/characters_repository.dart';
import 'package:rick_and_morty/response_model.dart';

class CharactersViewModel with ChangeNotifier {
  bool isLoading = false;

  String error = '';

  final _repository = CharactersRepository();

  final listController = ScrollController();

  List<Character> filteredCharactersList = [];

  List<Character> fullCharactersList = [];

  String? errorMessage = '';

  bool _showSearchBar = false;

  String searchNameText = '';

  Character? selectedCharacter;

  final searchBarController = TextEditingController();

  StreamSubscription<List<Character>>? listStreamSubscription;

  bool get showSearchBar => _showSearchBar;

  set showSearchBar(bool value) {
    _showSearchBar = value;
    notifyListeners();
  }

  setSelectedCharacter(Character selected) {
    selectedCharacter = selected;
    notifyListeners();
  }

  CharactersViewModel() {
    listController.addListener(loadNextPage);
    listStreamSubscription = _repository.charactersListStream.listen((onData) {
      errorMessage = '';
      fullCharactersList.addAll(onData);
      _filterData();
    });
    _repository.fetchData().catchError((e) {
      errorMessage = e.toString();
      notifyListeners();
    });
  }

  Future loadNextPage() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    if ((fullCharactersList.isEmpty) ||
        (fullCharactersList.length <
                (_repository.charactersResponse?.info?.count ?? 0) &&
            listController.position.pixels >=
                listController.position.maxScrollExtent)) {
      await _repository.fetchData().catchError((e) {
        errorMessage = e.toString();
        notifyListeners();
      });
    }
    isLoading = false;
    notifyListeners();
  }

  onSearchChanged(String text) async {
    if (text.length < 3) {
      if (filteredCharactersList.length < fullCharactersList.length) {
        filteredCharactersList.clear();
        filteredCharactersList.addAll(fullCharactersList);
      }
      listController.animateTo(listController.position.maxScrollExtent,
          duration: Duration(milliseconds: 10), curve: Curves.linear);
      notifyListeners();
      return;
    }

    searchNameText = text;

    filteredCharactersList.clear();

    for (var character in fullCharactersList) {
      if (character.name != null &&
          character.name!
              .toLowerCase()
              .contains(searchNameText.toLowerCase())) {
        filteredCharactersList.add(character);
      }
    }

    notifyListeners();

    if (filteredCharactersList.length < 20) {
      isLoading = true;
      notifyListeners();
      await _repository.fetchData().catchError((e) {
        errorMessage = e.toString();
        notifyListeners();
      });
      isLoading = false;
      notifyListeners();
    }
  }

  _filterData() {
    filteredCharactersList.clear();

    if (searchNameText.isEmpty) {
      filteredCharactersList.addAll(fullCharactersList);
    } else {
      for (var character in fullCharactersList) {
        if (character.name != null &&
            character.name!
                .toLowerCase()
                .contains(searchNameText.toLowerCase())) {
          filteredCharactersList.add(character);
        }
      }
    }
    notifyListeners();
  }

  clearSearch() {
    showSearchBar = !showSearchBar;
    searchNameText = '';
    searchBarController.text = '';
    _filterData();
  }

  @override
  void dispose() {
    listStreamSubscription?.cancel();
    super.dispose();
  }
}
