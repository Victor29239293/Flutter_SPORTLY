import 'package:flutter_app_sportly/infrastructure/models/scoredb/table_posiciones_soccer.dart';

class Estadistic {
  final int count;
  final Filters filters;
  final CompetitionScore competitionScore;
  final Season season;
  final List<Scorer> scorers;

  Estadistic({
    required this.count,
    required this.filters,
    required this.competitionScore,
    required this.season,
    required this.scorers,
  });

  factory Estadistic.fromJson(Map<String, dynamic> json) => Estadistic(
        count: json["count"] ?? 0,
        filters: Filters.fromJson(json["filters"] ?? {}),
        competitionScore: CompetitionScore.fromJson(json["competition"] ?? {}),
        season: Season.fromJson(json["season"] ?? {}),
        scorers: (json["scorers"] as List?)?.map((x) => Scorer.fromJson(x)).toList() ?? [],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "filters": filters.toJson(),
        "competitionScore": competitionScore.toJson(),
        "season": season.toJson(),
        "scorers": scorers.map((x) => x.toJson()).toList(),
      };
}


class Filters {
  final String season;
  final int limit;

  Filters({
    required this.season,
    required this.limit,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        season: json["season"] ?? "Unknown",
        limit: json["limit"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "season": season,
        "limit": limit,
      };
}

class Scorer {
  final Player player;
  final Team team;
  final int playedMatches;
  final int goals;
  final int assists;
  final int penalties;

  Scorer({
    required this.player,
    required this.team,
    this.playedMatches = 0,
    this.goals = 0,
    this.assists = 0,
    this.penalties = 0,
  });

  factory Scorer.fromJson(Map<String, dynamic> json) => Scorer(
        player: Player.fromJson(json["player"] ?? {}),
        team: Team.fromJson(json["team"] ?? {}),
        playedMatches: json["playedMatches"] ?? 0,
        goals: json["goals"] ?? 0,
        assists: json["assists"] ?? 0,
        penalties: json["penalties"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "player": player.toJson(),
        "team": team.toJson(),
        "playedMatches": playedMatches,
        "goals": goals,
        "assists": assists,
        "penalties": penalties,
      };
}

class Player {
  final int id;
  final String name;
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String nationality;
  final String section;
  final dynamic position;
  final int? shirtNumber;
  final DateTime? lastUpdated;

  Player({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    required this.nationality,
    required this.section,
    this.position,
    this.shirtNumber,
    this.lastUpdated,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json["id"] ?? 0,
        name: json["name"] ?? "Unknown",
        firstName: json["firstName"] ?? "Unknown",
        lastName: json["lastName"] ?? "Unknown",
        dateOfBirth: json["dateOfBirth"] != null
            ? DateTime.tryParse(json["dateOfBirth"])
            : null,
        nationality: json["nationality"] ?? "Unknown",
        section: json["section"] ?? "Unknown",
        position: json["position"],
        shirtNumber: json["shirtNumber"],
        lastUpdated: json["lastUpdated"] != null
            ? DateTime.tryParse(json["lastUpdated"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "firstName": firstName,
        "lastName": lastName,
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "nationality": nationality,
        "section": section,
        "position": position,
        "shirtNumber": shirtNumber,
        "lastUpdated": lastUpdated?.toIso8601String(),
      };
}

class Team {
  final int id;
  final String name;
  final String shortName;
  final String tla;
  final String? crest;
  final String address;
  final String website;
  final int founded;
  final String clubColors;
  final String venue;
  final DateTime? lastUpdated;

  Team({
    required this.id,
    required this.name,
    required this.shortName,
    required this.tla,
    this.crest,
    required this.address,
    required this.website,
    required this.founded,
    required this.clubColors,
    required this.venue,
    this.lastUpdated,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"] ?? 0,
        name: json["name"] ?? "Unknown",
        shortName: json["shortName"] ?? "Unknown",
        tla: json["tla"] ?? "Unknown",
        crest: json["crest"],
        address: json["address"] ?? "Unknown",
        website: json["website"] ?? "Unknown",
        founded: json["founded"] ?? 0,
        clubColors: json["clubColors"] ?? "Unknown",
        venue: json["venue"] ?? "Unknown",
        lastUpdated: json["lastUpdated"] != null
            ? DateTime.tryParse(json["lastUpdated"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "shortName": shortName,
        "tla": tla,
        "crest": crest,
        "address": address,
        "website": website,
        "founded": founded,
        "clubColors": clubColors,
        "venue": venue,
        "lastUpdated": lastUpdated?.toIso8601String(),
      };
}

class Season {
  final int id;
  final String? startDate;
  final String? endDate;
  final int currentMatchday;
  final dynamic winner;

  Season({
    required this.id,
    this.startDate,
    this.endDate,
    required this.currentMatchday,
    this.winner,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        id: json["id"] ?? 0,
        startDate: json["startDate"],
        endDate: json["endDate"],
        currentMatchday: json["currentMatchday"] ?? 0,
        winner: json["winner"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startDate": startDate,
        "endDate": endDate,
        "currentMatchday": currentMatchday,
        "winner": winner,
      };
}
