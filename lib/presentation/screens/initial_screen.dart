import 'package:flutter/material.dart';
import 'package:flutter_app_sportly/infrastructure/models/scoredb/competition_scoredb.dart';
import 'package:flutter_app_sportly/presentation/screens/providers/consumir_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class InitialScreen extends ConsumerStatefulWidget {
  static const String name = 'initial-screen';
  const InitialScreen({super.key});

  @override
  ConsumerState<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends ConsumerState<InitialScreen> {
  int? selectedIndex;

  @override
  void initState() {
    ref.read(providerTorneo).obtenerCompetitions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final torneoProvider = ref.watch(providerTorneo);

    if (torneoProvider.isloading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final gridColumns = screenWidth > 600 ? 4 : 2; // Ajustar columnas según ancho.

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.search, color: Colors.white),
        title: const Text(
          'SPORTLY',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Icon(Icons.settings, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridColumns,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8, // Relación de aspecto.
          ),
          itemCount: torneoProvider.listaCompeticiones.length,
          itemBuilder: (context, index) {
            final competition = torneoProvider.listaCompeticiones[index];
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                context.push('/initial/home/${competition.code}/0');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue[800]
                      : const Color.fromARGB(255, 234, 225, 225),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [],
                ),
                child: CustomCompetition(
                  competition: competition,
                  isSelected: isSelected,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomCompetition extends StatelessWidget {
  const CustomCompetition({
    super.key,
    required this.competition,
    required this.isSelected,
  });

  final CompetitionElement competition;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.2; // Ajustar tamaño de iconos dinámicamente.

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          competition.emblem.endsWith('.svg')
              ? SvgPicture.network(
                  competition.emblem,
                  placeholderBuilder: (context) =>
                      const CircularProgressIndicator(),
                  height: iconSize,
                  width: iconSize,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  competition.emblem,
                  height: iconSize,
                  width: iconSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red);
                  },
                ),
          const SizedBox(height: 8),
          Text(
            competition.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
