import 'package:flutter/material.dart';
import 'package:flutter_app_sportly/infrastructure/models/scoredb/league_scoredb.dart';
import 'package:flutter_app_sportly/infrastructure/models/scoredb/match.dart';
import 'package:flutter_app_sportly/presentation/screens/providers/consumir_providers.dart';
import 'package:flutter_app_sportly/presentation/screens/providers/torneo_providers.dart';
import 'package:flutter_app_sportly/presentation/views/customs/lisview_campeones.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

// Ejemplo de HomeView como ConsumerStatefulWidget
class HomeView extends ConsumerStatefulWidget {
  final String code;
  const HomeView({super.key, required this.code});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late Future<League> league;

  @override
  void initState() {
    // ref.read(providerTorneo).obtenerPrimerosPartidos(widget.code);
    league = ref.read(providerTorneo.notifier).obtenerLeague(widget.code);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerPartido = ref.read(providerTorneo);
    // final code = widget.code;

    return Scaffold(
      body: FutureBuilder<League>(
        future: league,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SizedBox());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final league = snapshot.data!;
            return ListView(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ), // Ícono negro para visibilidad
                    onPressed: () {
                      Navigator.pop(context); // Navega hacia atrás
                    },
                  ),
                  title: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centra los elementos
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Fondo blanco para el emblema
                          shape: BoxShape
                              .circle, // Forma circular para un diseño elegante
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Sombra ligera
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(
                            8), // Espaciado interno para el emblema
                        child: Image.network(
                          league.emblem,
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image,
                                color: Colors.grey); // Ícono por defecto
                          },
                        ),
                      ),
                      // const SizedBox(
                      //     width: 5), // Espaciado entre el emblema y el texto
                      Expanded(
                        child: Text(
                          league.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            overflow:
                                TextOverflow.ellipsis, // Manejo de texto largo
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: true,
                  // actions: [
                  //   IconButton(
                  //     icon: const Icon(Icons.more_vert,
                  //         color: Colors.white), // Ícono negro para contraste
                  //     onPressed: () {
                  //       // Acciones adicionales
                  //     },
                  //   ),
                  // ],
                ),
                const SizedBox(height: 10),
                MoviesSlideshow(seasons: league.seasons),
                Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildOvalItem(
                            icon: Icons.summarize, // Icono para "Resumen"
                            label: 'Resumen',
                            code: widget.code,
                            index: 0,
                          ),
                          _buildOvalItem(
                            icon: Icons.leaderboard, // Icono para "Posiciones"
                            label: 'Posiciones',
                            code: widget.code,
                            index: 1,
                          ),
                          _buildOvalItem(
                            icon: Icons.bar_chart, // Icono para "Estadistica"
                            label: 'Estadistica',
                            code: widget.code,
                            index: 2,
                          ),
                          _buildOvalItem(
                            icon: Icons.sports_soccer, // Icono para "Jugadores"
                            label: 'Jugadores',
                            code: widget.code,
                            index: 3,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Match Schedule',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          // context.go('/initial/football_matches/$code/1');
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                providerPartido.isloading
                    ? _buildShimmerEffect() // Aquí mostramos el efecto shimmer
                    : _buildMatchList(providerPartido),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  // Método para mostrar el efecto shimmer cuando los partidos están cargando
  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: List.generate(
            3, // Aquí creamos 3 "partidos" para simular el efecto shimmer
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Método para mostrar la lista de partidos una vez cargados
  Widget _buildMatchList(TorneoProvider providerPartido) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: providerPartido.primeros3Partidos.length,
      itemBuilder: (context, index) {
        final partido = providerPartido.primeros3Partidos[index];
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: CustomPartidoMath(partido: partido));
      },
    );
  }
}

class _buildOvalItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String code;
  final int index;
  const _buildOvalItem({
    required this.icon,
    required this.label,
    required this.code,
    required this.index,
  });
  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/initial/home/$code/0');
        break;
      case 1:
        context.go('/initial/scores/$code/');
        break;
      case 2:
        context.go('/initial/statistics/$code/');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: GestureDetector(
        onTap: () => onItemTapped(context, index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 69, 91, 181),
                Color.fromARGB(255, 60, 68, 103), // Azul claro
                // Celeste pastel
              ],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPartidoMath extends StatelessWidget {
  const CustomPartidoMath({
    super.key,
    required this.partido,
  });

  final Matche partido;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
          children: [
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      partido.homeTeam.shortName.length > 10
                          ? partido.homeTeam.shortName.substring(0, 7)
                          : partido.homeTeam.shortName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        overflow: TextOverflow.ellipsis, // Maneja texto largo
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Image.network(
                    partido.homeTeam.crest,
                    height: 40,
                    width: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    partido.formattedDate,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    partido.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Image.network(
                    partido.awayTeam.crest,
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      partido.awayTeam.shortName.length > 10
                          ? partido.awayTeam.shortName.substring(0, 7)
                          : partido.awayTeam.shortName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        overflow: TextOverflow.ellipsis, // Maneja texto largo
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
