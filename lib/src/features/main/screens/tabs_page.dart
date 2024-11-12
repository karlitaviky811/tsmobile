import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/features/main/screens/calendar_services.dart';
import 'package:tsmobile/src/features/main/screens/reservations_screen.dart';
import 'package:tsmobile/src/features/main/screens/tab1_page.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  static const String route = 'home-tabs-route';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _NavigationModel(),
      child: const Scaffold(
        body: _Pages(),
        bottomNavigationBar: _Navigation(),
      ),
    );
  }
}

class _Navigation extends StatelessWidget {
  const _Navigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navegationModel = Provider.of<_NavigationModel>(context);
    return BottomNavigationBar(
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.shifting,
      currentIndex: navegationModel.paginaActual,
      onTap: (i) => navegationModel.paginaActual = i,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.sell_rounded), label: 'Servicios'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: 'Calendario'),
        BottomNavigationBarItem(
            icon: Icon(Icons.tips_and_updates), label: 'Repuestos'),
      ],
    );
  }
}

class _Pages extends StatelessWidget {
  const _Pages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navegationController = Provider.of<_NavigationModel>(context);
    return PageView(
      controller: navegationController.pageController,
      physics: const NeverScrollableScrollPhysics(),
      //physics: BouncingScrollPhysics(),
      children: const <Widget>[
        HomeScreen(),
        ReservationsScreenCLient(),
        CalendarScreen(),
        CalendarScreen(),
      ],
    );
  }
}

class _NavigationModel with ChangeNotifier {
  final PageController _pageController = PageController();
  int _paginaActual = 0;

  int get paginaActual => _paginaActual;

  set paginaActual(int valor) {
    _paginaActual = valor;
    _pageController.animateToPage(valor,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  PageController get pageController => _pageController;
}
