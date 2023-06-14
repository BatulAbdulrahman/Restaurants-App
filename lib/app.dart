import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nearby_restaurants_app/provider_setup.dart';
import 'package:nearby_restaurants_app/ui/router.dart';
import 'package:nearby_restaurants_app/ui/shared/themes.dart';
import 'package:provider/provider.dart';

import 'core/services/key_storage/key_storage_service.dart';
import 'generated/l10n.dart';
import 'locator.dart';

Future<Widget> initializeApp() async {
  return MyApp();
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp();

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    locator<KeyStorageService>().locale = 'en';

    if (locator<KeyStorageService>().locale!.isEmpty) {
      // ignore: deprecated_member_use
      locator<KeyStorageService>().locale = ui.window.locale.languageCode;
    }

    return MultiProvider(
      providers: providers,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
        debugShowCheckedModeBanner: false,
        theme: primaryMaterialTheme,
        themeMode: ThemeMode.light,
        locale: Locale(locator<KeyStorageService>().locale!, ''),
        localizationsDelegates: const [
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('ar', ''), // Arabic, no country code
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          //myLocale = deviceLocale ; // here you make your app language similar to device language , but you should check whether the localization is supported by your app
        },
        onGenerateTitle: (context) => '',
      ),
    );
  }
}
