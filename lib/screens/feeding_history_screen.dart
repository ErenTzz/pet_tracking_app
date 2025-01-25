import 'dart:io';

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/feeding_record.dart';
import '../services/database_service.dart';
import 'home_screen.dart';
import 'feeding_tracker_screen.dart';

class FeedingHistoryScreen extends StatefulWidget {
  const FeedingHistoryScreen({super.key});

  @override
  _FeedingHistoryScreenState createState() => _FeedingHistoryScreenState();
}

class _FeedingHistoryScreenState extends State<FeedingHistoryScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // Prevent refreshing the current page
    setState(() {
      _selectedIndex = index;
    });
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

  void _showFeedingHistory(Task pet) async {
    List<FeedingRecord> records =
        await _databaseService.getFeedingRecords(pet.id);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              '${pet.name[0].toUpperCase()}${pet.name.substring(1)} - Beslenme Geçmişi',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: records.map((record) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yemek Türü: ${record.foodType}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Yemek Saati: ${record.mealTime}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Miktar: ${record.amount} gram',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Su İçti mi: ${record.drankWater ? 'Evet' : 'Hayır'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _databaseService
                                .deleteFeedingRecord(record.id);
                            setState(() {
                              records.remove(record);
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Beslenme kaydı başarıyla silindi!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Beslenme Geçmişi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(1.5, 1.5),
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
                'Hadi İlk Evcil Dostumuzu Ekleyelim!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                Task pet = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    _showFeedingHistory(pet);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(pet.photoPath),
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pet.name[0].toUpperCase() + pet.name.substring(1),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
