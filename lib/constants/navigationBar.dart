import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:weekdays/constants/routes.dart';
import 'package:weekdays/views/HomePage.dart';
import '../Providers/Navigation.dart'; // Import your NavigationProvider

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    void navigateTo(int index) {
      // if (index != navigationProvider.selectedIndex) {
      navigationProvider.setIndex(index);
      // }

      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, homePageRoute);
          break;
        case 1:
          Navigator.pushReplacementNamed(context, habitStats);
          break;
        // case 2:
        //   Navigator.pushReplacementNamed(context, '/settings');
        //   break;
      }
    }

    return BottomNavigationBar(
      currentIndex: navigationProvider.selectedIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        // BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: navigateTo,
    );
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
