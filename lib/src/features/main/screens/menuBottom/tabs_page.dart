import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:tsmobile/src/features/main/screens/calendar/calendar_services.dart';
import 'package:tsmobile/src/features/main/screens/menuBottom/configurations/configurations_module.dart';
import 'package:tsmobile/src/features/main/screens/menuBottom/home/home_page.dart';
import 'package:tsmobile/src/features/main/screens/listTickets/list_tickets_page.dart';

import '../../constant/image.constant.dart';

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
      backgroundColor: Colors.transparent,
      selectedItemColor: const Color(0xff051937),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.shifting,
      currentIndex: navegationModel.paginaActual,
      onTap: (i) => navegationModel.paginaActual = i,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            ImageConstant.imgHome,
             height: 22,
             width: 22,
            color: navegationModel.paginaActual == 0 ? const Color(0xff051937) : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            ImageConstant.imgSearch,
            color: navegationModel.paginaActual == 1 ? const Color(0xff051937)  : Colors.grey,
          ),
          label: 'Servicios',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            ImageConstant.imgCalendar,
            color: navegationModel.paginaActual == 2 ? const Color(0xff051937) : Colors.grey,
          ),
          label: 'Calendario',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            ImageConstant.imgUser,
            color: navegationModel.paginaActual == 3 ? const Color(0xff051937) : Colors.grey,
          ),
          label: 'Configuración',
        ),
        
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
      children: <Widget>[
        const HomeScreen(),
        const TicketsListFiltered(),
        const CalendarScreen(),
        SettingsView(),
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
