import 'package:flutter/material.dart';
import 'package:FoodMenu/screens/weeklyMenuScreen.dart';
import '../webScraper.dart';

class MenuScreen extends StatefulWidget {
  final bool isDailySelected;

  MenuScreen({required this.isDailySelected});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<Map<String, dynamic>> futureMenu;
  TextEditingController _tcController = TextEditingController();
  String _bakiyeBilgi = '';

  @override
  void initState() {
    super.initState();
    futureMenu = MenuService.fetchMenu();

    _tcController.addListener(() {
      if (_tcController.text.isEmpty) {
        setState(() {
          _bakiyeBilgi = '';
        });
      }
    });
  }

  void _refreshMenu() {
    setState(() {
      futureMenu = MenuService.fetchMenu();
      _tcController.clear();
    });
  }

  void _showDailyMenu() {
    setState(() {
      futureMenu = MenuService.fetchMenu();
    });
  }

  void _showWeeklyMenu() {
    _tcController.clear();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeeklyMenuScreen(
          isDailySelected: false,
        ),
      ),
    );
  }

  void _submitTcNumber() async {
    String tcNumber = _tcController.text;
    if (tcNumber.isNotEmpty) {
      try {
        final response = await MenuService.fetchData(tcNumber);

        setState(() {
          _bakiyeBilgi = response;
        });
      } catch (error) {
        print("Hata: $error");
        setState(() {
          _bakiyeBilgi = "Bir hata oluştu";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20.0),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 231, 227, 227),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 231, 227, 227),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.17,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/kmbb_logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _showDailyMenu,
                  child: Text(
                    "GÜNLÜK MENÜ",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: const Color.fromARGB(255, 68, 67, 67),
                      fontFamily: "Schyler",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isDailySelected
                        ? Colors.red.withAlpha(150)
                        : Colors.red,
                    elevation: 0,
                    side: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _showWeeklyMenu,
                  child: Text(
                    "HAFTALIK MENÜ",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: const Color.fromARGB(255, 68, 67, 67),
                      fontFamily: "Schyler",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !widget.isDailySelected
                        ? Colors.red.withAlpha(150)
                        : Colors.red,
                    elevation: 0,
                    side: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: futureMenu,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    snapshot.data!['menuItems'].isEmpty) {
                  return Center(child: Text('Menü mevcut değil'));
                } else {
                  final String date =
                      snapshot.data?['menuDate'] ?? 'Tarih bulunamadı';
                  final List<String> menu =
                      List<String>.from(snapshot.data?['menuItems'] ?? []);

                  return Column(
                    children: [
                      Card(
                        color: const Color.fromARGB(255, 223, 218, 218),
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    fontFamily: "Schyler",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 68, 67, 67),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: _refreshMenu,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: const Color.fromARGB(255, 223, 218, 218),
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.3,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.3,
                                ),
                                child: Image.asset(
                                  'lib/assets/images/chef.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: menu.map((menuItem) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      menuItem,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        color: const Color.fromARGB(
                                            255, 68, 67, 67),
                                        fontFamily: "Schyler",
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _tcController,
                  cursorColor: const Color.fromARGB(255, 68, 67, 67),
                  decoration: InputDecoration(
                      labelText: "TC Kimlik Numarası",
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 68, 67, 67),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 223, 218, 218),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 68, 67, 67),
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitTcNumber,
                  child: Text(
                    "Bakiyeni Öğren",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 68, 67, 67),
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 223, 218, 218),
                  ),
                ),
                SizedBox(height: 10),
                if (_bakiyeBilgi.isNotEmpty)
                  Text(
                    'Bakiyeniz: $_bakiyeBilgi',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 68, 67, 67),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
