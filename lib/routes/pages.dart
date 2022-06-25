// ignore_for_file: constant_identifier_names, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:passify/bindings/firebase_binding.dart';
import 'package:passify/bindings/forum_binding.dart';
import 'package:passify/bindings/home_binding.dart';
import 'package:passify/bindings/navigator_binding.dart';
import 'package:passify/bindings/notification_binding.dart';
import 'package:passify/bindings/profile_binding.dart';
import 'package:passify/bindings/search_binding.dart';
import 'package:passify/views/error/not_found_page.dart';
import 'package:passify/views/forum/community_page.dart';
import 'package:passify/views/forum/detail_post_page.dart';
import 'package:passify/views/forum/detail_trend.dart';
import 'package:passify/views/forum/edit_post_page.dart';
import 'package:passify/views/forum/event_page.dart';
import 'package:passify/views/forum/hobby_page.dart';
import 'package:passify/services/service_preference.dart';
import 'package:passify/views/bottom_navigator.dart';
import 'package:passify/views/home/all_categories_page.dart';
import 'package:passify/views/home/categories_page.dart';
import 'package:passify/views/home/home_page.dart';
import 'package:passify/views/login/login_page.dart';
import 'package:passify/views/login/onboarding_page.dart';
import 'package:passify/views/profile/edit_profile_page.dart';
import 'package:passify/views/profile/profile_person_page.dart';
import 'package:passify/views/register/register_page.dart';
import 'package:passify/views/search/search_page.dart';

part 'routes.dart';

class AppPages {
  static const SPLASH = _Paths.SPLASH;
  static const NAVIGATOR = _Paths.NAVIGATOR;
  static const HOME = _Paths.HOME;
  static const ALL_CATEGORIES = _Paths.ALL_CATEGORIES;
  static const CATEGORIES = _Paths.CATEGORIES;
  static const HOBBY = _Paths.HOBBY;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const DETAIL_INFO = _Paths.DETAIL_INFO;
  static const LOGIN = _Paths.LOGIN;
  static const SEARCH = _Paths.SEARCH;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const DETAIL_EVENT = _Paths.DETAIL_EVENT;
  static const DETAIL_POST = _Paths.DETAIL_POST;
  static const DETAIL_TREND = _Paths.DETAIL_TREND;
  static const EDIT_POST = _Paths.EDIT_POST;
  static const COMMUNITY = _Paths.COMMUNITY;
  static const PROFILE_PERSON = _Paths.PROFILE_PERSON;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const NOT_FOUND = _Paths.NOT_FOUND;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const NAVIGATOR = '/';
  static const HOME = '/home';
  static const ALL_CATEGORIES = '/all-categories';
  static const CATEGORIES = '/categories';
  static const SEARCH = '/search';
  static const HOBBY = '/hobby/';
  static const ONBOARDING = '/onboarding';
  static const DETAIL_INFO = '/detail';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const DETAIL_EVENT = '/detail-event/';
  static const DETAIL_POST = '/detail-post/';
  static const DETAIL_TREND = '/detail-trend/';
  static const EDIT_POST = '/edit-post/';
  static const COMMUNITY = '/community/';
  static const PROFILE_PERSON = '/profile-person/';
  static const EDIT_PROFILE = '/edit-profile';
  static const NOT_FOUND = '/404';
}
