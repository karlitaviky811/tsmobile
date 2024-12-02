import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:tsmobile/src/features/main/screens/calendar_services.dart';
import 'package:tsmobile/src/features/main/screens/home_page.dart';
import 'package:tsmobile/src/features/main/screens/list_tickets_page.dart';
import 'package:tsmobile/src/features/main/screens/settings_page.dart';
import 'package:tsmobile/src/features/main/screens/settings_page2.dart';
import 'package:tsmobile/src/widgets/maps_test.dart';

import '../constant/image.constant.dart';

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
      selectedItemColor: Color(0xff051937),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.shifting,
      currentIndex: navegationModel.paginaActual,
      onTap: (i) => navegationModel.paginaActual = i,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            ImageConstant.imgHome,
            color: navegationModel.paginaActual == 0 ? Color(0xff051937) : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            ImageConstant.imgSearch,
            color: navegationModel.paginaActual == 1 ? Color(0xff051937)  : Colors.grey,
          ),
          label: 'Servicios',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            ImageConstant.imgCalendar,
            color: navegationModel.paginaActual == 2 ? Color(0xff051937) : Colors.grey,
          ),
          label: 'Calendario',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            ImageConstant.imgCalendar,
            color: navegationModel.paginaActual == 3 ? Color(0xff051937) : Colors.grey,
          ),
          label: 'Repuestos',
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
      children: const <Widget>[
        HomeScreen(),
        TicketsListFiltered(),
        CalendarScreen(),
        //SettingsPage2(),
        MyMapPage(),
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
