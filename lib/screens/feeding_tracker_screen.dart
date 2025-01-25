import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database_service.dart';
import 'home_screen.dart';
import 'feeding_history_screen.dart';

class FeedingTrackerScreen extends StatefulWidget {
  const FeedingTrackerScreen({super.key});

  @override
  _FeedingTrackerScreenState createState() => _FeedingTrackerScreenState();
}

class _FeedingTrackerScreenState extends State<FeedingTrackerScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final List<String> _foodTypes = ['Kuru mama', 'Yaş mama', 'Ev yemeği'];
  final List<String> _mealTimes = ['Sabah', 'Öğle', 'Akşam'];
  final Map<int, String?> _selectedFoodTypes = {};
  final Map<int, String?> _selectedMealTimes = {};
  final Map<int, TextEditingController> _amountControllers = {};
  final Map<int, bool> _drankWaters = {};

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const HomeScreen(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const FeedingTrackerScreen(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const FeedingHistoryScreen(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }

  void _saveFeedingDetails(Task pet) async {
    if (_selectedFoodTypes[pet.id] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yemek Türü boş olamaz!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (_selectedMealTimes[pet.id] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yemek Saati boş olamaz!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (_amountControllers[pet.id]?.text.isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Miktar boş olamaz!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    await _databaseService.addFeedingRecord(
      pet.id,
      _selectedFoodTypes[pet.id]!,
      _selectedMealTimes[pet.id]!,
      double.parse(_amountControllers[pet.id]!.text),
      _drankWaters[pet.id] ?? false,
    );
    print('Feeding details saved for ${pet.name}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Beslenme takibi kaydedildi!'),
        duration: Duration(seconds: 2),
      ),
    );

    setState(() {
      _selectedFoodTypes[pet.id] = null;
      _selectedMealTimes[pet.id] = null;
      _amountControllers[pet.id]?.clear();
      _drankWaters[pet.id] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Beslenme Takibi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
      ),
      body: StreamBuilder<List<Task>>(
        stream: _databaseService.watchTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Haydi İlk Evcil Dostumuzu Ekleyelim!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                Task pet = snapshot.data![index];
                _amountControllers.putIfAbsent(
                    pet.id, () => TextEditingController());
                return StatefulBuilder(
                  builder: (context, setState) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                pet.name[0].toUpperCase() +
                                    pet.name.substring(1),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Yemek Türü',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                prefixIcon: const Icon(Icons.fastfood),
                              ),
                              value: _selectedFoodTypes[pet.id],
                              items: _foodTypes.map((String foodType) {
                                return DropdownMenuItem<String>(
                                  value: foodType,
                                  child: Text(foodType),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedFoodTypes[pet.id] = value;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Yemek Saati',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                prefixIcon: const Icon(Icons.schedule),
                              ),
                              value: _selectedMealTimes[pet.id],
                              items: _mealTimes.map((String mealTime) {
                                return DropdownMenuItem<String>(
                                  value: mealTime,
                                  child: Text(mealTime),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMealTimes[pet.id] = value;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _amountControllers[pet.id],
                              decoration: InputDecoration(
                                labelText: 'Miktar (gram)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                prefixIcon: const Icon(Icons.scale),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Su İçti mi?',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Checkbox(
                                  value: _drankWaters[pet.id] ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      _drankWaters[pet.id] = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    _saveFeedingDetails(pet);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'Kaydet',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Beslenme Takibi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Beslenme Geçmişi',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
