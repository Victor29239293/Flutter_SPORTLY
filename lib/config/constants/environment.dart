import 'package:flutter_dotenv/flutter_dotenv.dart';


class Environment {

  static String theScoreKey = dotenv.env['THE_DATA_SCORE_KEY'] ?? 'No hay api key';


}