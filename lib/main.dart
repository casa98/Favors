import 'package:do_favors/theme/app_theme.dart';
import 'package:do_favors/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_state_notifier.dart';
import 'shared/strings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateNotifier()),
      ],
      child: Consumer<AppStateNotifier>(builder: (context, appState, child) {
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
