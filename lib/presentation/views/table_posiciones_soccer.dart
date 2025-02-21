import 'package:flutter/material.dart';
import 'package:flutter_app_sportly/infrastructure/models/scoredb/table_posiciones_soccer.dart'
    as scoredb;

import 'package:flutter_app_sportly/infrastructure/models/scoredb/table_posiciones_soccer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_sportly/presentation/screens/providers/consumir_providers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScoresViews extends ConsumerStatefulWidget {
  static const name = 'ScoresScreen';
  final String code;

  const ScoresViews({super.key, required this.code});

  @override
  ConsumerState<ScoresViews> createState() => _ScoresViewsState();
}

class _ScoresViewsState extends ConsumerState<ScoresViews> {
  late Future<Estadistica> estadistica;

  @override
  void initState() {
    super.initState();
    estadistica =
        ref.read(providerTorneo.notifier).obtenerEstadisticas(widget.code);
  }

  String getYear(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('y').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final code = widget.code;
    // final accentColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.go('/initial/home/$code/0'),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Posiciones',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: FutureBuilder<Estadistica>(
        future: estadistica,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: textColor),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.standings.isEmpty) {
            return Center(
              child: Text(
                'No hay datos de posiciones disponibles.',
                style: TextStyle(color: textColor),
              ),
            );
          }

          final competition = snapshot.data!.competition;
          final standings = snapshot.data!.standings;
          final season = snapshot.data!.season;

          return ListView.builder(
            itemCount: standings.length,
            itemBuilder: (context, index) {
              final standing = standings[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
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
                    child: Row(
                      children: [
                        // Competition Emblem
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: competition.emblem!.endsWith('.svg')
                              ? SvgPicture.network(
                                  competition.emblem!,
                                  placeholderBuilder: (context) =>
                                      const CircularProgressIndicator(),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  competition.emblem!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error,
                                        color: Colors.red);
                                  },
                                ),
                        ),
                        const SizedBox(width: 12),
                        // Competition Name and Season
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              competition.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${getYear(season.startDate)} - ${getYear(season.endDate)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTable(standing.table, context),
                  const Divider(color: Colors.grey),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTable(List<scoredb.Table> table, BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A44),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: const [
                Expanded(flex: 1, child: Text('Pos.', style: _headerStyle)),
                Expanded(flex: 2, child: SizedBox()), // Espacio para el ícono
                Expanded(flex: 3, child: Text('Equipo', style: _headerStyle)),
                Expanded(flex: 1, child: Text('PJ', style: _headerStyle)),
                Expanded(flex: 1, child: Text('Pts', style: _headerStyle)),
                Expanded(flex: 1, child: Text('GF', style: _headerStyle)),
                Expanded(flex: 1, child: Text('GC', style: _headerStyle)),
                Expanded(flex: 1, child: Text('GD', style: _headerStyle)),
              ],
            ),
          ),
          const Divider(color: Colors.grey),

          // Data Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: table.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey, height: 1),
            itemBuilder: (context, index) {
              final item = table[index];
              final rowColor = index % 2 == 0
                  ? Colors.transparent
                  : Colors.black12; // Alternar color de fila

              return Container(
                color: rowColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    // Posición
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.position}',
                        style: TextStyle(color: textColor),
                      ),
                    ),

                    // Escudo del equipo
                    Expanded(
                      flex: 2,
                      child: _buildTeamCrest(item.team.crest),
                    ),

                    // Nombre del equipo
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.team.tla,
                        style: TextStyle(color: textColor),
                      ),
                    ),

                    // Partidos jugados
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.playedGames}',
                        style: TextStyle(color: textColor),
                      ),
                    ),

                    // Puntos
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.points}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    // Goles a favor
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.goalsFor}',
                        style: TextStyle(color: textColor),
                      ),
                    ),

                    // Goles en contra
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.goalsAgainst}',
                        style: TextStyle(color: textColor),
                      ),
                    ),

                    // Diferencia de goles
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${item.goalDifference}',
                        style: TextStyle(
                          color: item.goalDifference > 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  Widget _buildTeamCrest(String crestUrl) {
    return crestUrl.endsWith('.svg')
        ? SvgPicture.network(
            crestUrl,
            placeholderBuilder: (context) => const CircularProgressIndicator(),
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          )
        : Image.network(
            crestUrl,
            height: 30,
            width: 30,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error, color: Colors.red),
          );
  }
}
