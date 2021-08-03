import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:do_favors/provider/user_provider.dart';
import 'package:do_favors/theme/app_theme.dart';
import 'package:do_favors/router/app_router.dart';
import 'theme/app_state_notifier.dart';
import 'shared/strings.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeNotifier()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<AppThemeNotifier>(builder: (_, appState, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          onGenerateRoute: AppRouter.buildRootRouteFactory(),
          initialRoute: Strings.initialRoute,
        );
      }),
    );
  }
}
