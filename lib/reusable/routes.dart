import 'package:chat_app/reusable/utils/app_components.dart';
import 'package:flutter/material.dart';
import '../home_layout/home_layout.dart';
import '../screens/login_screen/login_screen.dart';
import '../screens/profile_screen/profile_screen.dart';
import '../screens/register_screen/register_screen.dart';

class Routes {
  static const String login = "login";
  static const String register = "/";
  static const String home = "home";
  static const String profile = "profile";
}

class AppRoutes extends Routes {
  static Route onGenerate(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (context) => unDefineRoute());
    }
  }
}
