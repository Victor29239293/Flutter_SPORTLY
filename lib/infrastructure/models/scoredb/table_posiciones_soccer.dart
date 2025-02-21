import 'package:flutter_app_sportly/infrastructure/models/scoredb/competition_scoredb.dart';

class Estadistica {
  final Filters filters;
  final Area area;
  final CompetitionScore competition;
  final CurrentSeason season;
  final List<Standing> standings;

  Estadistica({
    required this.filters,
    required this.area,
    required this.competition,
    required this.season,
    required this.standings,
  });

  factory Estadistica.fromJson(Map<String, dynamic> json) => Estadistica(
        filters: Filters.fromJson(json["filters"]),
        area: Area.fromJson(json["area"]),
        competition: CompetitionScore.fromJson(json["competition"]),
        season: CurrentSeason.fromJson(json["season"]),
        standings: List<Standing>.from(
            json["standings"].map((x) => Standing.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filters": filters.toJson(),
        "area": area.toJson(),
        "competition": competition.toJson(),
        "season": season.toJson(),
        "standings": List<dynamic>.from(standings.map((x) => x.toJson())),
      };
}

class Filters {
  final String season;

  Filters({
    required this.season,
  });

  factory Filters.fromJson(Map<String, dynamic> json) => Filters(
        season: json["season"],
      );

  Map<String, dynamic> toJson() => {
        "season": season,
      };
}


class CompetitionScore {
  final int id;
  final String name;
  final String code;
  final String type;
  final String? emblem;

  CompetitionScore({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.emblem,
  });

  factory CompetitionScore.fromJson(Map<String, dynamic> json) =>
      CompetitionScore(
        id: json["id"] ?? 0,
        name: json["name"] ?? "Unknown",
        code: json["code"] ?? "Unknown",
        type: json["type"] ?? "Unknown",
        emblem: json["emblem"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "type": type,
        "emblem": emblem,
      };
}

class Standing {
  final String stage;
  final String type;
  final dynamic group;
  final List<Table> table;

  Standing({
    required this.stage,
    required this.type,
    required this.group,
    required this.table,
  });

  factory Standing.fromJson(Map<String, dynamic> json) => Standing(
        stage: json["stage"],
        type: json["type"],
        group: json["group"],
        table: List<Table>.from(json["table"].map((x) => Table.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stage": stage,
        "type": type,
        "group": group,
        "table": List<dynamic>.from(table.map((x) => x.toJson())),
      };
}

class Table {
  final int position;
  final Team team;
  final int playedGames;
  final dynamic form;
  final int won;
  final int draw;
  final int lost;
  final int points;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;

  Table({
    required this.position,
    required this.team,
    required this.playedGames,
    required this.form,
    required this.won,
    required this.draw,
    required this.lost,
    required this.points,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
  });

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        position: json["position"],
        team: Team.fromJson(json["team"]),
        playedGames: json["playedGames"],
        form: json["form"],
        won: json["won"],
        draw: json["draw"],
        lost: json["lost"],
        points: json["points"],
        goalsFor: json["goalsFor"],
        goalsAgainst: json["goalsAgainst"],
        goalDifference: json["goalDifference"],
      );

  Map<String, dynamic> toJson() => {
        "position": position,
        "team": team.toJson(),
        "playedGames": playedGames,
        "form": form,
        "won": won,
        "draw": draw,
        "lost": lost,
        "points": points,
        "goalsFor": goalsFor,
        "goalsAgainst": goalsAgainst,
        "goalDifference": goalDifference,
      };
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

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"],
        name: json["name"],
        shortName: json["shortName"],
        tla: json["tla"],
        crest: json["crest"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "shortName": shortName,
        "tla": tla,
        "crest": crest,
      };
}
