import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/Book_provider.dart';
import 'Provider/theme.dart';
import 'Screens/Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'MyBooks',
            theme: themeProvider.getTheme(),
            home: HomeScreen(),
            debugShowCheckedModeBanner: false
          );
        },
      ),
    );
  }
}
