class Competition {
    final int count;
    final List<CompetitionElement> competitions;

    Competition({
        required this.count,
        required this.competitions,
    });

    factory Competition.fromJson(Map<String, dynamic> json) => Competition(
        count: json["count"] ?? 0,
        competitions: List<CompetitionElement>.from(
            (json["competitions"] ?? []).map((x) => CompetitionElement.fromJson(x))
        ),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "competitions": List<dynamic>.from(competitions.map((x) => x.toJson())),
    };
}

class CompetitionElement {
    final int id;
    final Area area;
    final String name;
    final String code;
    final String type;
    final String emblem;
    final String plan;
    final CurrentSeason currentSeason;
    final int numberOfAvailableSeasons;
    final String lastUpdated;

    CompetitionElement({
        required this.id,
        required this.area,
        required this.name,
        required this.code,
        required this.type,
        required this.emblem,
        required this.plan,
        required this.currentSeason,
        required this.numberOfAvailableSeasons,
        required this.lastUpdated,
    });

    factory CompetitionElement.fromJson(Map<String, dynamic> json) => CompetitionElement(
        id: json["id"] ?? 0,
        area: Area.fromJson(json["area"] ?? {}),
        name: json["name"] ?? '',
        code: json["code"] ?? '',
        type: json["type"] ?? '',
        emblem: json["emblem"] ?? '',
        plan: json["plan"] ?? '',
        currentSeason: CurrentSeason.fromJson(json["currentSeason"] ?? {}),
        numberOfAvailableSeasons: json["numberOfAvailableSeasons"] ?? 0,
        lastUpdated: json["lastUpdated"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "area": area.toJson(),
        "name": name,
        "code": code,
        "type": type,
        "emblem": emblem,
        "plan": plan,
        "currentSeason": currentSeason.toJson(),
        "numberOfAvailableSeasons": numberOfAvailableSeasons,
        "lastUpdated": lastUpdated,
    };
}

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

    factory Area.fromJson(Map<String, dynamic> json) => Area(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        code: json["code"] ?? '',
        flag: json["flag"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "flag": flag,
    };
}

class CurrentSeason {
    final int id;
    final String startDate;
    final String endDate;
    final int currentMatchday;
    final Winner? winner;

    CurrentSeason({
        required this.id,
        required this.startDate,
        required this.endDate,
        required this.currentMatchday,
        required this.winner,
    });

    factory CurrentSeason.fromJson(Map<String, dynamic> json) => CurrentSeason(
        id: json["id"] ?? 0,
        startDate: json["startDate"] ?? '',
        endDate: json["endDate"] ?? '',
        currentMatchday: json["currentMatchday"] ?? 0,
        winner: json["winner"] == null ? null : Winner.fromJson(json["winner"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "startDate": startDate,
        "endDate": endDate,
        "currentMatchday": currentMatchday,
        "winner": winner?.toJson(),
    };
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

    factory Winner.fromJson(Map<String, dynamic> json) => Winner(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        shortName: json["shortName"] ?? '',
        tla: json["tla"] ?? '',
        crest: json["crest"] ?? '',
        address: json["address"] ?? '',
        website: json["website"] ?? '',
        founded: json["founded"] ?? 0,
        clubColors: json["clubColors"] ?? '',
        venue: json["venue"] ?? '',
        lastUpdated: json["lastUpdated"] ?? '',
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
        "lastUpdated": lastUpdated,
    };
}