import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sportly/infrastructure/models/scoredb/competition_scoredb.dart';
import 'package:flutter_app_sportly/infrastructure/models/scoredb/league_scoredb.dart';
import 'package:flutter_app_sportly/infrastructure/models/scoredb/match.dart';
import 'package:flutter_app_sportly/infrastructure/models/scoredb/stadistic_specific.dart';

import 'package:flutter_app_sportly/infrastructure/models/scoredb/table_posiciones_soccer.dart';

class TorneoProvider extends ChangeNotifier {
  final dio =
      Dio(BaseOptions(baseUrl: 'https://api.football-data.org/v4', headers: {
    'X-Auth-Token': "0217b02d9bc24f4c94d74e196cd6c72f",
  }));
  List<CompetitionElement> listaCompeticiones = [];
  bool isloading = false;
  List<Matche> primeros3Partidos = [];
  List<Matche> todosPartidos = [];
  List<Scorer> goleadores = [];

  Future<void> obtenerCompetitions() async {
    if (listaCompeticiones.isNotEmpty) return;
    isloading = true;
    try {
      final response = await dio.get('/competitions');
      final competitionResponse = Competition.fromJson(response.data);
      listaCompeticiones = competitionResponse.competitions;
      isloading = false;
      notifyListeners();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        print(
            'Límite de solicitudes alcanzado. Por favor, verifica tu API token o intenta más tarde.');
      } else {
        print('Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
      }
    } catch (e) {
      print('Unknown Error: $e');
    }
  }

  Future<League> obtenerLeague(String code) async {
    final response = await dio.get('/competitions/$code');
    final competitionResponse = League.fromJson(response.data);
    await obtenerPrimerosPartidos(code);
    isloading = false;
    notifyListeners(); // This will ensure the UI updates when the seasons data is fetched
    return competitionResponse;
  }

  Future<void> obtenerPrimerosPartidos(String code) async {
    isloading = true;
    try {
      final response = await dio.get('/competitions/$code/matches');
      final competitionResponse = MatchesResponse.fromJson(response.data);
      primeros3Partidos = competitionResponse.matches
          .where(
            (element) => element.status == 'TIMED',
          )
          .take(3)
          .toList();
      isloading = false;
      notifyListeners();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        print(
            'Límite de solicitudes alcanzado. Por favor, verifica tu API token o intenta más tarde.');
      } else {
        print('Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
      }
    } catch (e) {
      print('Unknown Error: $e');
    }
  }

  Future<Estadistica> obtenerEstadisticas(String code) async {
    final response = await dio.get('/competitions/$code/standings');

    final estadisticas = Estadistica.fromJson(response.data);

    isloading = false;
    notifyListeners();
    return estadisticas;
  }

  Future<Estadistic> obtenerGoleadorCompetition(String code) async {
    final response = await dio.get('/competitions/$code/scorers');
    print('Sucess response ${response}');
    final estadisticaResponse = Estadistic.fromJson(response.data);

    isloading = false;
    notifyListeners();
    return estadisticaResponse;
  }

  Future<void> obtenerTodosLosPartidos(String code) async {
    isloading = true;
    try {
      final response = await dio.get('/competitions/$code/matches');
      final competitionResponse = MatchesResponse.fromJson(response.data);
      todosPartidos = competitionResponse.matches;

      isloading = false;
      notifyListeners();
    } on DioException catch (e) {
      isloading = false;
      if (e.response?.statusCode == 403) {
        print(
            'Límite de solicitudes alcanzado. Por favor, verifica tu API token o intenta más tarde.');
      } else {
        print('Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
      }
    } catch (e) {
      isloading = false;
      print('Unknown Error: $e');
    }
  }
}
