import 'package:intl/intl.dart';

class Area {
  final int id;
  final String name;
  final String code;
  final String flag;

  Area({
    required this.id,
    required this.name,
    required this.code,
    required this.flag,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      flag: json['flag'] ?? '',
    );
  }
}

class Winner {
  final int id;
  final String name;
  final String shortName;
  final String tla;
  final String crest;
  final String address;
  final String website;
  final int founded;
  final String clubColors;
  final String venue;
  final String lastUpdated;

  Winner({
    required this.id,
    required this.name,
    required this.shortName,
    required this.tla,
    required this.crest,
    required this.address,
    required this.website,
    required this.founded,
    required this.clubColors,
    required this.venue,
    required this.lastUpdated,
  });

  factory Winner.fromJson(Map<String, dynamic> json) {
    return Winner(
      id: json['id'],
      name: json['name'] ?? '',
      shortName: json['shortName'] ?? '',
      tla: json['tla'] ?? '',
      crest: json['crest'] ?? '',
      address: json['address'] ?? '',
      website: json['website'] ?? '',
      founded: json['founded'] ?? 0,
      clubColors: json['clubColors'] ?? '',
      venue: json['venue'] ?? '',
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }
}

class CurrentSeason {
  final int id;
  final String startDate;
  final String endDate;
  final int currentMatchday;
  final Winner? winner; // Puede ser null si no hay ganador

  CurrentSeason({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.currentMatchday,
    this.winner,
  });

  factory CurrentSeason.fromJson(Map<String, dynamic> json) {
    return CurrentSeason(
      id: json['id'],
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      currentMatchday: json['currentMatchday'] ?? 0,
      winner: json['winner'] != null ? Winner.fromJson(json['winner']) : null,
    );
  }
}

class Season {
  final int id;
  final String startDate;
  final String endDate;
  final int currentMatchday;
  final Winner? winner;

  Season({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.currentMatchday,
    this.winner,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      currentMatchday: json['currentMatchday'] ?? 0,
      winner: json['winner'] != null ? Winner.fromJson(json['winner']) : null,
    );
  }

  /// Método para formatear las fechas en el estilo requerido.
  /// Método para formatear las fechas en el estilo requerido.
  String formattedDate(String date) {
    try {
      // Convierte la cadena ISO a un objeto DateTime
      final parsedDate = DateTime.parse(date);

      // Aplica el formato deseado
      final formattedDate = DateFormat("d MMMM yyyy", 'es').format(parsedDate);
      // print(formattedDate);
      return formattedDate;
    } catch (e) {
      // Si el formato de la fecha no es válido, devuelve la fecha original.
      return date;
    }
  }
}

class League {
  final int id;
  final String name;
  final String code;
  final String type;
  final String emblem;
  final Area area;
  final CurrentSeason currentSeason;
  final List<Season> seasons;
  final String lastUpdated;

  League({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.emblem,
    required this.area,
    required this.currentSeason,
    required this.seasons,
    required this.lastUpdated,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      type: json['type'] ?? '',
      emblem: json['emblem'] ?? '',
      area: Area.fromJson(json['area']),
      currentSeason: CurrentSeason.fromJson(json['currentSeason']),
      seasons:
          (json['seasons'] as List).map((e) => Season.fromJson(e)).toList(),
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }
}