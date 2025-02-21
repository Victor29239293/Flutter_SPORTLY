import 'package:flutter_app_sportly/infrastructure/models/scoredb/competition_scoredb.dart';
import 'package:intl/intl.dart';

class MatchesResponse {
  final Map<String, dynamic> filters;
  final ResultSet resultSet;
  final Competition competition;
  final List<Matche> matches;

  MatchesResponse({
    required this.filters,
    required this.resultSet,
    required this.competition,
    required this.matches,
  });

  factory MatchesResponse.fromJson(Map<String, dynamic> json) {
    return MatchesResponse(
      filters: json['filters'],
      resultSet: ResultSet.fromJson(json['resultSet']),
      competition: Competition.fromJson(json['competition']),
      matches: (json['matches'] as List)
          .map((matchJson) => Matche.fromJson(matchJson))
          .toList(),
    );
  }
}

class ResultSet {
  final int count;
  final String first;
  final String last;
  final int played;

  ResultSet({
    required this.count,
    required this.first,
    required this.last,
    required this.played,
  });

  factory ResultSet.fromJson(Map<String, dynamic> json) {
    return ResultSet(
      count: json['count'],
      first: json['first'],
      last: json['last'],
      played: json['played'],
    );
  }
}

class Team {
  final int id;
  final String name;
  final String shortName;
  final String tla;
  final String crest;

  Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.tla,
    required this.crest,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0, // Valor predeterminado: 0
      name: json['name'] ?? 'Unknown', // Valor predeterminado: 'Unknown'
      shortName: json['shortName'] ?? 'Unknown', // Valor predeterminado: 'Unknown'
      tla: json['tla'] ?? 'N/A', // Valor predeterminado: 'N/A'
      crest: json['crest'] ?? 'default_url', // Valor predeterminado: URL por defecto
    );
  }
}

class Referee {
  final int id;
  final String name;
  final String type;
  final String? nationality;

  Referee({
    required this.id,
    required this.name,
    required this.type,
    this.nationality,
  });
  

  factory Referee.fromJson(Map<String, dynamic> json) {
    return Referee(
      id: json['id'] ?? 0, // Valor predeterminado: 0
      name: json['name'] ?? 'Unknown', // Valor predeterminado: 'Unknown'
      type: json['type'] ?? 'Unknown', // Valor predeterminado: 'Unknown'
      nationality: json['nationality'] ?? 'Unknown', // Valor predeterminado: 'Unknown'
    );
  }
  
}

class Matche {
  final int id;
  final String utcDate;
  final String status;
  final int matchday;
  final String stage;
  final Team homeTeam;
  final Team awayTeam;
  final Score score;
  final List<Referee> referees;

  Matche({
    required this.id,
    required this.utcDate,
    required this.status,
    required this.matchday,
    required this.stage,
    required this.homeTeam,
    required this.awayTeam,
    required this.score,
    required this.referees,
  });

   String get formattedDate {
  DateTime parsedDate = DateTime.parse(utcDate); // Convierte el string ISO en DateTime
  return DateFormat('d MMM y').format(parsedDate); // Formato "25 SEP 2025"
}

  factory Matche.fromJson(Map<String, dynamic> json) {
    return Matche(
      id: json['id'] ?? 0, // Valor predeterminado: 0
      utcDate: json['utcDate'] ?? 'N/A', // Valor predeterminado: 'N/A'
      status: json['status'] ?? 'Unknown', // Valor predeterminado: 'Unknown'
      matchday: json['matchday'] ?? 0, // Valor predeterminado: 0
      stage: json['stage'] ?? 'Unknown', // Valor predeterminado: 'Unknown'
      homeTeam: Team.fromJson(json['homeTeam'] ?? {}),
      awayTeam: Team.fromJson(json['awayTeam'] ?? {}),
      score: Score.fromJson(json['score'] ?? {}),
      referees: (json['referees'] as List?)
              ?.map((referee) => Referee.fromJson(referee))
              .toList() ??
          [], // Valor predeterminado: lista vacía
    );
  }
}

class Score {
  final String winner;
  final String duration;
  final FullTime fullTime;

  Score({
    required this.winner,
    required this.duration,
    required this.fullTime,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      winner: json['winner'] ?? 'Unknown', // Valor predeterminado: 'Unknown'
      duration: json['duration'] ?? 'Unknown', // Valor predeterminado: 'Unknown'
      fullTime: FullTime.fromJson(json['fullTime'] ?? {}),
    );
  }
}

class FullTime {
  final int home;
  final int away;

  FullTime({
    required this.home,
    required this.away,
  });

  factory FullTime.fromJson(Map<String, dynamic> json) {
    return FullTime(
      home: json['home'] ?? 0, // Valor predeterminado: 0
      away: json['away'] ?? 0, // Valor predeterminado: 0
    );
  }
}