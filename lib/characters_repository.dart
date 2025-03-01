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
      _fetchCharacters('https://rickandmortyapi.com/api/character')
          .catchError((e) {
        throw e.message;
      });
    } else {
      if (charactersResponse?.info?.next != null) {
        await _fetchCharacters(charactersResponse!.info!.next!).catchError((e) {
          _tryAgain();
          throw e;
        });
      }
    }
  }

  Future _fetchCharacters(String url) async {
    final response = await http.get(Uri.parse(url)).catchError((e) {
      throw (e.message);
    });
    if (response.statusCode != 200) {
      throw Exception('Something is wrong, please try again later');
    } else {
      charactersResponse = CharactersResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);

      _controller.add(charactersResponse?.charactersList ?? []);
    }
  }

  _tryAgain() {
    Future.delayed(const Duration(seconds: 2), () {
      fetchData();
    });
  }
}
