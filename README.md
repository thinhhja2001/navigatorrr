# Navigator 2.0

Navigation là một chức năng chính trong Mobile App Development. Nó cho phép người dùng chuyển từ màn hình này sang màn hình khác. Kiểm soát Navigation tốt giúp cho app của chúng ta đươc tổ chức tốt hơn, nâng cao hiệu suất.

## Bắt đầu nào

## Navigator 1.0

Navigator 1.0
Với Navigator 1.0, các bạn có thể đã quá quen thuộc với những khái niệm sau:

- [Navigator](https://master-api.flutter.dev/flutter/widgets/Navigator-class.html): Một widget dùng để quản lý một chồng các đối tượng Route(được lưu dưới dạng Stack)
- [Route](https://master-api.flutter.dev/flutter/widgets/Route-class.html): Một đối tượng được quản lý bởi một Navigator đại diện cho một màn hình, thường được thực hiện bởi các lớp MaterialPageRoute.

Trước Navigator 2.0, Routes đã được đẩy và đưa vào ngăn xếp Navigator của các _định tuyến được đặt tên_ hoặc các _định tuyến ẩn danh_.

## Cùng tìm hiểu về Định tuyến ẩn danh

Với Navigator, một cách đơn giản nhất để bạn

- Hiển thị một màn hình mới là sử dụng phương thức `Navigator.of(context).push()`
- Quay lại màn hình trước đó bằng `Navigator.of(context).pop()`

Ví dụ:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test ne hihi'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Login screen'),
          ///Sử dụng Navigator.push để di chuyển đến trang LoginScreen
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("this is login screen"),
      ),
    );
  }
}

```

Khi hàm `push()` được gọi, widget LoginScreen được đặt lên trên HomeScreen như sau:
![](https://i.ibb.co/2MPN7Qt/navigator-push.png)
Màn hình trước (HomeScreen) vẫn là một phần của cây widget, vì vậy bất kỳ đối tượng State nào được liên kết với nó vẫn ở xung quanh trong khi LoginScreen được hiển thị

## Bây giờ sẽ là các định tuyến được đặt tên

Flutter cũng sử dụng các định tuyến được đặt tên, được xác định trong tham số routes trên MaterialApp hoặc CupertinoApp

Bây giờ, ở class MyApp, thêm vào tham số routes như sau:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: <String, WidgetBuilder>{
        "/signin": (context) => const LoginScreen(),
      },
      home: const HomeScreen(),
    );
  }
}
```

Bây giờ, ở màn hình HomeScreen, thay vì dùng Navigator.push(), chúng ta sẽ sử dụng Navigator.pushNamed()

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test ne hihi'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Login screen'),
          onPressed: () => Navigator.of(context).pushNamed('/signin'),
        ),
      ),
    );
  }
}
```

Vậy sự khác nhau giữa _Định tuyến được đặt tên_ và _Định tuyến không được đặt tên_ là gì?

Hãy chạy thử phiên bản web
Đây là đường dẫn của màn hình LoginScreen khi sử dụng `Navigator.push()`
![](https://i.ibb.co/QHVvk9W/image.png)
Đây là đường dẫn của màn hình LoginScreen khi sử dụng `Navigator.pushNamed()`
![](https://i.ibb.co/6nx76j6/image.png)

Như các bạn có thể thấy, `Navigator.push()` chỉ đơn thuần là đưa một màn hình lên trên cây widget nhưng nó sẽ không thay đổi đường dẫn. Còn `Navigator.pushNamed()` sẽ thay đổi luôn đường dẫn. Đó chính là sự khác nhau giữa _Định tuyến ẩn danh_ và _Định tuyến được đặt tên_

Tuy nhiên, do các định tuyến này phải được xác định trước. Vì vậy, nếu ứng dụng của bạn chạy trên web, bạn không thể phân tích cú pháp ID từ một định tuyến như _/details/id_

## onGenerateRoute

Một phương pháp để xử lý vấn đề gặp phải của _Định tuyến được đặt tên_ đó chính là sử dụng onGenerateRoute. API này cho phép bạn xử lý được tất cả các đường dẫn.

```dart
onGenerateRoute: (settings) {
  // Handle '/'
  if (settings.name == '/') {
    return MaterialPageRoute(builder: (context) => HomeScreen());
  }

  // Handle '/details/:id'
  var uri = Uri.parse(settings.name);
  if (uri.pathSegments.length == 2 &&
  uri.pathSegments.first == 'details') {
    var id = uri.pathSegments[1];
    return MaterialPageRoute(builder: (context) => DetailScreen(id: id,),);
  }

  return MaterialPageRoute(builder: (context) => UnknownScreen(),);
},

```

Full example

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        // Handle '/'
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => const HomeScreen());
        }

        // Handle '/login/:id'
        var uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'login') {
          var id = uri.pathSegments[1];
          return MaterialPageRoute(builder: (context) => LoginScreen(id: id));
        }

        return MaterialPageRoute(builder: (context) => const UnknownScreen());
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to login'),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/login/1',
            );
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  String id;

  LoginScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Showing login screen for id $id'),
            ElevatedButton(
              child: const Text('Pop!'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('404!'),
      ),
    );
  }
}
```

## Navigator 2.0

Navigator 2.0 thêm các lớp mới vào framework để làm cho màn hình của ứng dụng trở thành một chức năng của trạng thái ứng dụng và cung cấp khả năng phân tích cú pháp các định tuyến từ nền tảng bên dưới(như URL web).

Hãy xem cách chúng ta có thể làm điều này
![](https://200lab-blog.imgix.net/2021/07/image-168.png)

Cùng liệt kê những thành phần có trong sơ đồ trên và công dụng của nó:

- Page: Một immutable object được dùng để set _Navigator_ history stack
- Router: Cấu hình danh sách các trang sẽ được hiển thị bởi _Navigator_. Thông thường thì danh sách các trang này thay đổi dựa trên nền tảng cơ bản hoặc trạng thái của ứng dụng thay đổi.
- RouteInformationParser sẽ lấy _RouteInformation_ từ RouteInformationProvider và phân tích cú pháp đó để biến thành một kiểu dữ liệu do người dùng xác định.
- RouterDelegate - xác định hành vi dành riêng cho ứng dụng về cách thức mà Router tìm hiểu về những thay đổi trong trạng thái ứng dụng và cách ứng dụng phản ứng với chúng. Công việc của nó là lắng nghe RouteInformationParser và trạng thái ứng dụng, sau đó xây dựng _Navigator_ với danh sách các _Pages_ hiện tại
- BackButtonDispatcher: báo cáo các lần nhấn nút quay lại cho Router

Bây giờ, chúng ta sẽ đi vào việc xây dựng một ứng dụng bằng cách sử dụng Navigator 2.0

Trước tiên, hãy tạo kiểu dữ liệu chung của chúng ta, trong đó route sẽ được chuyển đổi thông qua _RouteInformationParser_

```dart
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
```

Trong class trên, chúng ta có 2 biến: _pathName_, sẽ là tham số URL (sau "/") và boolean, sẽ hiển thị trang 404(Không xác định) trong trường hợp tham số không hợp lệ.

Ngoài ra, chúng ta sẽ tạo thêm một số named constructors.

`HomeRoutePath.home()` hiển thị initial screen khi route là "/". Trong trường hợp này, _isUnknown_ sẽ là false và _pathName_ sẽ là trống.

`HomeRoutePath.otherPage()` dành cho các trang _pathName_. Ví dụ /xyz.

`HomeRoutePath.unknown()` dành cho các đường dẫn không xác định.

Sau đó, chúng ta sẽ tạo RouteInformationParser để chuyển đổi URL thành HomeRoutePath của chúng ta.

```dart

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
```

Ở đây, chúng ta sẽ mở rộng _RouterInformationParser_ với type _parseRouteInformation_ method để chịu trách nhiệm phân tích (parsing) cú pháp đường dẫn URL thành _HomeRoutePath_.

Khi chúng ta không có phân đoạn đường dẫn (zero path segments) (pathSegments sau "/" ví dụ /abc/xyz có 2 phân đoạn đường dẫn)

Ngoài ra, chúng ta còn có 1 method khác để override, được gọi là _restoreRouteInformation_. Method này sẽ lưu trữ lịch sử duyệt web trên trình duyệt. Ở đây, chúng ta đã chuyển đường dẫn đến _RouteInformation_ theo _HomeRoutePath_ state

Bây giờ, chúng ta đã hoàn thành informationParser.

Hãy chuyển sang _RouterDelegate_.

Class này cần mở rộng _RouterDelegate_ với type _HomeRoutePath_. Nó có 5 override method và chúng ta không cần xử lý tất cả chúng. _addListener_ và _removeListener_, chúng ta có thể sử dụng _ChangeNotifier_ và thêm nó vào function.

Ngoài ra đối với _popRoute_, chúng ta có thể sử dụng mixin _PopNavigatorRouterDelegateMixin_

```dart
class HomeRouterDelegate extends RouterDelegate<HomeRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<HomeRoutePath> {
  String pathName;
  bool isError = false;

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  HomeRoutePath get currentConfiguration {
    if (isError) return HomeRoutePath.unKown();

    if (pathName == null) return HomeRoutePath.home();

    return HomeRoutePath.otherPage(pathName);
  }

  void onTapped(String path) {
    pathName = path;
    print(pathName);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
            key: ValueKey('HomePage'),
            child: HomePage(
              onTapped: (String path) {
                pathName = path;
                notifyListeners();
              },
            ),
          ),
          if (isError)
            MaterialPage(key: ValueKey('UnknownPage'), child: UnkownPage())
          else if (pathName != null)
            MaterialPage(
                key: ValueKey(pathName),
                child: PageHandle(
                  pathName: pathName,
                ))
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;

          pathName = null;
          isError = false;
          notifyListeners();

          return true;
        });
  }

  @override
  Future<void> setNewRoutePath(HomeRoutePath homeRoutePath) async {
    if (homeRoutePath.isUnkown) {
      pathName = null;
      isError = true;
      return;
    }

    if (homeRoutePath.isOtherPage) {
      if (homeRoutePath.pathName != null) {
        pathName = homeRoutePath.pathName;
        isError = false;
        return;
      } else {
        isError = true;
        return;
      }
    } else {
      pathName = null;
    }
  }
}
```

Ở đây, chúng ta đã xác định hai state mà chúng ta sẽ sử dụng để điều hướng đến các trang. Một là _pathName_ và một là cho các trang lỗi _isError_

Bắt đầu với từng override method:

- _currentConfiguration_: được gọi bởi [Router] khi nó phát hiện các thông tin route có thể thay đổi do rebuild. Vì vậy, theo các điều kiện, chúng ta đang call các _HomePageRoute_ constructors.
- _setNewRoutePath_: Phương thức này xử lý việc định tuyến khi người dùng nhập URL vào trình duyệt và thay đổi state thông qua HomePage và nếu _pathName_ không rỗng, chúng ta có thể map tên với các trang và hiển thị các trang khác nhau theo các route khác nhau(ở đây, mình chỉ hiển thị một trang có tên route).

Bước cuối cùng là thêm _routerDelegate_ và _routerInformationParser_ của chúng ta vào `MaterialApp.router()` bên trong `main.dart`

````dart
void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Flutter Navigaton 2.0",
      routerDelegate: HomeRouterDelegate(),
      routeInformationParser: HomeRouteInformationParser(),
    );
  }
}
````
