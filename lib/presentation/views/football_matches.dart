import 'package:flutter/material.dart';
import 'package:flutter_app_sportly/presentation/screens/providers/consumir_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_sportly/presentation/screens/providers/torneo_providers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class FootballMatches extends ConsumerStatefulWidget {
  static const String name = 'Football_matches';
  final String code;
  final int pageIndex;

  const FootballMatches(
      {super.key, required this.code, required this.pageIndex});

  @override
  ConsumerState<FootballMatches> createState() => _FootballMatchesState();
}

class _FootballMatchesState extends ConsumerState<FootballMatches> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Cargar los partidos al iniciar la pantalla
    ref.read(providerTorneo).obtenerTodosLosPartidos(widget.code).then((_) {
      _scrollToTimedMatch();
    });
  }

  void _scrollToTimedMatch() {
    final torneoProvider = ref.read(providerTorneo);
    final index = torneoProvider.todosPartidos.indexWhere(
      (partido) => partido.status == 'TIMED',
    );
    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          index * 120.0, // Altura aproximada de cada ítem
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final torneoProvider = ref.watch(providerTorneo);
    final code = widget.code;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF252538),
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/initial/home/$code/0'),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Football Matches',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: torneoProvider.isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : torneoProvider.todosPartidos.isEmpty
              ? const Center(
                  child: Text('No hay partidos disponibles'),
                )
              : _buildMatchList(torneoProvider),
    );
  }

  Widget _buildMatchList(TorneoProvider torneoProvider) {
    final groupedMatches = <String, List<dynamic>>{};
    // Agrupar partidos por matchday
    for (var partido in torneoProvider.todosPartidos) {
      final matchday = partido.matchday.toString();
      groupedMatches.putIfAbsent(matchday, () => []).add(partido);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: groupedMatches.length,
      itemBuilder: (context, index) {
        final matchday = groupedMatches.keys.elementAt(index);
        final matches = groupedMatches[matchday]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado del matchday
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Matchday $matchday',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            ...matches.map((partido) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomPartidoMath(partido: partido),
              );
            }),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class CustomPartidoMath extends StatelessWidget {
  final dynamic partido;

  const CustomPartidoMath({super.key, required this.partido});

  String _formatDate(String utcDate) {
    final parsedDate = DateTime.parse(utcDate);
    final formattedDate =
        '${parsedDate.day}/${parsedDate.month}/${parsedDate.year} ${parsedDate.hour}:${parsedDate.minute}';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A44),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   'UEFA Champions League, ROUND OF 16 - 2nd Leg',
              //   style: TextStyle(
              //     color: Colors.grey,
              //     fontSize: 12,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildTeamInfo(
                      partido.homeTeam.crest,
                      partido.homeTeam.name,
                      partido.score.fullTime.home?.toString() ?? '-',
                    ),
                  ),
                  Text(
                    partido.status == 'TIMED'
                        ? _formatDate(partido.utcDate)
                        : 'FT',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: _buildTeamInfo(
                      partido.awayTeam.crest,
                      partido.awayTeam.name,
                      partido.score.fullTime.away?.toString() ?? '-',
                      isHomeTeam: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '2nd Leg - advance ',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamInfo(String crest, String name, String score,
      {bool isHomeTeam = true}) {
    return Row(
      mainAxisAlignment:
          isHomeTeam ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isHomeTeam) ...[
          _buildCrest(crest),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment:
                isHomeTeam ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1, // Asegura que no ocupe más de una línea
              ),
              Text(
                score,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (!isHomeTeam) ...[
          const SizedBox(width: 10),
          _buildCrest(crest),
        ],
      ],
    );
  }

  Widget _buildCrest(String crestUrl) {
    return crestUrl.endsWith('.svg')
        ? SvgPicture.network(
            crestUrl,
            height: 40,
            width: 40,
          )
        : Image.network(
            crestUrl,
            height: 40,
            width: 40,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) =>
                    const Icon(
              Icons.error,
              color: Colors.white,
            ),
          );
  }
}
