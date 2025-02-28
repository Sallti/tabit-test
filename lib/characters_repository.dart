import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rick_and_morty/response_model.dart';

class CharactersRepository {
  CharactersResponse? charactersResponse;

  final StreamController<List<Character>> _controller = StreamController();

  Stream<List<Character>> get charactersListStream => _controller.stream;

  Future fetchData() async {
    if (charactersResponse == null) {
      _fetchCharacters('https://rickandmortyapi.com/api/character');
    } else {
      if (charactersResponse?.info?.next != null) {
        _fetchCharacters(charactersResponse!.info!.next!);
      }
    }
  }

  Future _fetchCharacters(String url) async {
    await http.get(Uri.parse(url)).catchError((e) {
      throw e;
    }).then((onValue) {
      charactersResponse = CharactersResponse.fromJson(
          jsonDecode(onValue.body) as Map<String, dynamic>);

      _controller.add(charactersResponse?.charactersList ?? []);
    });
  }
}
