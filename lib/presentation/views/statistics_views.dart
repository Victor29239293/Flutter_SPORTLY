import 'package:flutter/material.dart';
import 'package:flutter_app_sportly/infrastructure/models/scoredb/stadistic_specific.dart';
import 'package:flutter_app_sportly/presentation/screens/providers/consumir_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class StatisticsViews extends ConsumerStatefulWidget {
  static const name = 'Statistics_views';
  final String code;

  const StatisticsViews({super.key, required this.code});

  @override
  _StatisticsViewsState createState() => _StatisticsViewsState();
}

class _StatisticsViewsState extends ConsumerState<StatisticsViews> {
  late Future<Estadistic> estadistic;

  @override
  void initState() {
    super.initState();
    estadistic = ref
        .read(providerTorneo.notifier)
        .obtenerGoleadorCompetition(widget.code);
  }

  String getYear(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('y').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final code = widget.code;
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF252538),
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/initial/home/$code/0'),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'ESTADÍSTICA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Estadistic>(
        future: estadistic,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.scorers.isEmpty) {
            return const Center(
              child: Text(
                'No hay datos de posiciones disponibles.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final competition = snapshot.data!.competitionScore;
          final scorer = snapshot.data!.scorers;
          final season = snapshot.data!.season;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Competition Info
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
                            season.startDate != null && season.endDate != null
                                ? '${getYear(season.startDate!)} - ${getYear(season.endDate!)}'
                                : 'Temporada no disponible',
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

                Container(
                  padding: const EdgeInsets.all(12.0),
                  child: const Text(
                    'GOLEADORES',
                    style:  TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
               
                // Scorers Table
                Expanded(
                  child: _buildTable(scorer, context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTable(List<Scorer> table, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A44),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.separated(
        itemCount: table.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          height: 1,
        ),
        itemBuilder: (context, index) {
          final item = table[index];
          final isEvenRow = index % 2 == 0;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: isEvenRow ? Colors.transparent : Colors.black12,
            child: Row(
              children: [
                Text('${index + 1}.',
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 10),
                _buildTeamCrest(item.team.crest!),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.player.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  '${item.goals}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamCrest(String crestUrl) {
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
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error, color: Colors.red),
          );
  }
}
