import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigator20/pages/home_page.dart';
import 'package:navigator20/pages/page_handle.dart';
import 'package:navigator20/pages/unknown_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Flutter Navigation 2.0",
      routerDelegate: HomeRouterDelegate(),
      routeInformationParser: HomeRouteInformationParser(),
    );
  }
}

class HomeRoutePath {
  final String? pathName; //Đường link đến các trang
  final bool isUnknown; //Xuất hiện trang 404

  HomeRoutePath.home()
      : pathName = null,
        isUnknown = false;

  HomeRoutePath.otherPage(this.pathName) : isUnknown = false;

  HomeRoutePath.unKnown()
      : pathName = null,
        isUnknown = true;

  bool get isHomePage => pathName == null;
  bool get isOtherPage => pathName != null;
}

class HomeRouteInformationParser extends RouteInformationParser<HomeRoutePath> {
  @override
  Future<HomeRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return HomeRoutePath.home();
    } else if (uri.pathSegments.length == 1) {
      final pathName = uri.pathSegments.elementAt(0).toString();
      if (pathName == null) return HomeRoutePath.unKnown();
      return HomeRoutePath.otherPage(pathName);
    }
    return HomeRoutePath.unKnown();
  }

  @override
  RouteInformation? restoreRouteInformation(HomeRoutePath configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: '/error');
    }
    if (configuration.isHomePage) {
      return const RouteInformation(location: '/');
    }
    if (configuration.isOtherPage) {
      return RouteInformation(location: '/${configuration.pathName}');
    }
    return null;
  }
}

class HomeRouterDelegate extends RouterDelegate<HomeRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  TextEditingController textEditingController = TextEditingController();
  String? pathName;
  bool isError = false;

  static final HomeRouterDelegate _homeRouterDelegate =
      HomeRouterDelegate._internal();

  factory HomeRouterDelegate() {
    return _homeRouterDelegate;
  }

  HomeRouterDelegate._internal();
  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  HomeRoutePath get currentConfiguration {
    if (isError) return HomeRoutePath.unKnown();
    if (pathName == null) return HomeRoutePath.home();
    return HomeRoutePath.otherPage(pathName);
  }

  void onTapped(String path) {
    pathName = path;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(
          key: ValueKey('HomePage'),
          child: HomePage(),
        ),
        if (isError)
          const MaterialPage(
            child: UnknownPage(),
          )
        else if (pathName != null)
          MaterialPage(
            child: PageHandle(
              pathName: pathName!,
            ),
          )
      ],
      onPopPage: (route, result) {
        if (route.didPop(result)) return false;
        pathName = null;
        isError = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(HomeRoutePath configuration) async {
    if (configuration.isUnknown) {
      pathName = null;
      isError = true;
      notifyListeners();

      return;
    }
    if (configuration.isOtherPage) {
      if (configuration.pathName != null) {
        pathName = configuration.pathName;
        isError = false;
        notifyListeners();

        return;
      } else {
        isError = true;
        notifyListeners();

        return;
      }
    } else {
      pathName = null;
      notifyListeners();
    }
  }
}
