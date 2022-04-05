// ignore_for_file: constant_identifier_names, prefer_const_constructors

part of 'pages.dart';

class AppRoutes {
  static const INITIAL = AppPages.LOGIN;

  static final pages = [
    GetPage(
        name: _Paths.LOGIN,
        page: () => LoginPage(),
        binding: FirebaseBinding()),
    GetPage(name: _Paths.REGISTER, page: () => RegisterPage()),
    GetPage(name: _Paths.HOME, page: () => HomePage()),
    GetPage(name: _Paths.ALL_CATEGORIES, page: () => AllCategoriesPage()),
    GetPage(name: _Paths.CATEGORIES, page: () => CategoriesPage()),
    GetPage(name: _Paths.HOBBY + ':hobby', page: () => HobbyPage()),
    GetPage(name: _Paths.DETAIL_EVENT + ':event', page: () => EventPage()),
    GetPage(name: _Paths.EDIT_PROFILE, page: () => EditProfilePage()),
    GetPage(
        name: _Paths.NAVIGATOR,
        page: () => BottomNavigator(),
        bindings: [
          NavigatorBinding(),
          HomeBinding(),
          SearchBinding(),
          ForumBinding(),
          NotificationBinding(),
          ProfileBinding(),
          FirebaseBinding()
        ],
        transition: Transition.downToUp),
  ];
}
