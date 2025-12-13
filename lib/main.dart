import 'dart:math';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'services/api_service.dart';
import 'screens/meal_detail_screen.dart';
import 'models/meal.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> openRandomMealFromNotification() async {
  try {
    final List<Meal> meals = await ApiService().fetchMealsByCategory('Beef');
    if (meals.isEmpty) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
      return;
    }

    final rand = Random();
    final randomMeal = meals[rand.nextInt(meals.length)];

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => MealDetailScreen(mealId: randomMeal.id),
      ),
    );
  } catch (e) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('FIREBASE OK');
  } catch (e) {
    print('FIREBASE ERROR: $e');
  }

  tz.initializeTimeZones();

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      _onNotificationTap(response.payload);
    },
  );

  await scheduleRandomDailyRecipeNotification();

  runApp(const MealApp());
}

class MealApp extends StatelessWidget {
  const MealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Meal Explorer',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: HomeScreen(),
    );
  }
}

void _onNotificationTap(String? payload) {
  openRandomMealFromNotification();
}

Future<void> scheduleRandomDailyRecipeNotification() async {
  final now = tz.TZDateTime.now(tz.local);

  var scheduled = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    20,
    0,
  );


  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }

  await flutterLocalNotificationsPlugin.zonedSchedule(
    1,
    'Рецепт на денот',
    'Отвори ја апликацијата и види нов рецепт!',
    scheduled,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_recipe_channel',
        'Daily Recipe',
        channelDescription: 'Дневна нотификација со рецепт',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );

  print('Scheduled daily recipe notification at 20:00');
}







