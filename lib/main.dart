import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list08flu/database/app_database.dart';
import 'package:todo_list08flu/database/app_repository.dart';
import 'package:todo_list08flu/home/home_cubit.dart';
import 'package:todo_list08flu/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list08flu/home/onboarding_page.dart';


late final AppDatabase appDatabase;
late final AppRepository appRepository;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final preferences = await SharedPreferences.getInstance();
  final isDarkTheme = preferences.getBool('isDarkTheme') ?? false;
  final isOnboardShown = preferences.getBool('isOnboardShown') ?? false;

  await Hive.initFlutter();
  await Hive.openBox('todoBox');

  appDatabase = AppDatabase();
  appRepository = AppRepositoryImpl(db: appDatabase);

  print("Dark Theme: $isDarkTheme | Onboard Shown: $isOnboardShown");
  
  runApp(MyApp(isDarkTheme: isDarkTheme, isOnboardShown: isOnboardShown));
}

class MyApp extends StatefulWidget {
  final bool isDarkTheme;
  final bool isOnboardShown;

  const MyApp({
    super.key, 
    required this.isDarkTheme, 
    required this.isOnboardShown,
  });

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkTheme;
  late final HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.isDarkTheme;
    _cubit = HomeCubit(repo: appRepository);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _changeTheme(bool value) async {
    setState(() {
      _isDarkTheme = value;
    });
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isDarkTheme', value);
  } 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: widget.isOnboardShown
          ? BlocProvider(
              create: (_) => _cubit,
              child: MyHomePage(
                isDarkTheme: _isDarkTheme, 
                onThemeChanged: _changeTheme,
              ),
            )
          : OnboardingPage(
              isDarkTheme: _isDarkTheme,
              onThemeChanged: _changeTheme,
            ),
    );
  }
}
