import 'package:flutter/material.dart';
import 'package:FoodMenu/notification.dart';
import 'screens/dailyMenuScreen.dart'; 
import 'webScraper.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

  
  await scheduleDailyMenuNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yemek Menüsü',
      theme: ThemeData(
      ),
      
      
    
      home: MenuScreen(isDailySelected: true,),
    );
  }
}

Future<void> scheduleDailyMenuNotification() async {
  try {
    final menuData = await MenuService.fetchMenu();
    final String date = menuData['menuDate'] ?? 'Tarih bulunamadı';
    final List<String> menuItems = List<String>.from(menuData['menuItems'] ?? []);
    final String menu = menuItems.join(', ');

    await LocalNotifications.scheduleDailyNotification(
      title: 'Bugünün Yemek Menüsü - $date',
      body: menu,
      payload: 'daily_menu',
      hour: 10,  
      minute: 38,
    );
  } catch (e) {
    print('Bildirimi ayarlarken hata oluştu: $e');
  }
}
