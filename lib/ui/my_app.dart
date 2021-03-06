import 'package:flutter_boilerplate_project/constants/app_theme.dart';
import 'package:flutter_boilerplate_project/constants/strings.dart';
import 'package:flutter_boilerplate_project/data/repository.dart';
import 'package:flutter_boilerplate_project/di/components/service_locator.dart';
import 'package:flutter_boilerplate_project/ui/demo/demo_provider.dart';
import 'package:flutter_boilerplate_project/ui/demo/life_widget.dart';
import 'package:flutter_boilerplate_project/utils/routes/routes.dart';
import 'package:flutter_boilerplate_project/stores/language/language_store.dart';
import 'package:flutter_boilerplate_project/stores/post/post_store.dart';
import 'package:flutter_boilerplate_project/stores/theme/theme_store.dart';
import 'package:flutter_boilerplate_project/stores/user/user_store.dart';
import 'package:flutter_boilerplate_project/ui/home/home.dart';
import 'package:flutter_boilerplate_project/ui/login/login.dart';
import 'package:flutter_boilerplate_project/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final ThemeStore _themeStore = ThemeStore(getIt<Repository>());
  final PostStore _postStore = PostStore(getIt<Repository>());
  final LanguageStore _languageStore = LanguageStore(getIt<Repository>());
  final UserStore _userStore = UserStore(getIt<Repository>());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ThemeStore>(create: (_) => _themeStore),
        Provider<PostStore>(create: (_) => _postStore),
        Provider<LanguageStore>(create: (_) => _languageStore),
      ],
      child: Observer(
        name: 'global-observer',
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Strings.appName,
            // theme: _themeStore.darkMode ? themeDataDark : themeData,
            routes: Routes.routes,
            // initialRoute: Routes.splash,
            locale: Locale(_languageStore.locale),
            supportedLocales: _languageStore.supportedLanguages
                .map((language) => Locale(language.locale!, language.code))
                .toList(),
            localizationsDelegates: [
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
              // Built-in localization of basic text for Cupertino widgets
              GlobalCupertinoLocalizations.delegate,
            ],
            home: DemoLifeWidget(),
          );
        },
      ),
    );
  }
}