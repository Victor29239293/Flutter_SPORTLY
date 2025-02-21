import 'package:flutter/material.dart';
import 'package:flutter_app_sportly/presentation/views/customs/customs_navigator.dart';
import 'package:flutter_app_sportly/presentation/views/home_views.dart';
import 'package:flutter_app_sportly/presentation/views/table_posiciones_soccer.dart';

import 'package:flutter_app_sportly/presentation/views/watch_views.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home_screen';
  final int pageIndex;
  final String code;

  const HomeScreen({
    super.key,
    required this.pageIndex,
    required this.code,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Lógica para actualizar la vista según el pageIndex
    if (pageController.hasClients) {
      pageController.animateToPage(
        widget.pageIndex,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
      );
    }

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          HomeView(code: widget.code),
          ScoresViews(code : widget.code),
          const WatchScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: widget.pageIndex,
        code: widget.code,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
