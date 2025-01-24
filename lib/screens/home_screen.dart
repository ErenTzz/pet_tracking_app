import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_tracking_app/services/database_service.dart';
import '../models/task.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final ImagePicker _picker = ImagePicker();
  String? _name;
  String? _type;
  int? _age;
  String? _breed;
  String? _photoPath;
  double? _weight;
  String? _healthStatus;
  int _selectedIndex = 0;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/settings');
    }
  }

  void _addTask() async {
    print('Add Task button pressed');
    if (_name == null ||
        _name!.isEmpty ||
        _type == null ||
        _type!.isEmpty ||
        _age == null ||
        _breed == null ||
        _breed!.isEmpty ||
        _photoPath == null ||
        _weight == null ||
        _healthStatus == null ||
        _healthStatus!.isEmpty) {
      // Show an error message or handle the validation error
      print('Please fill all fields');
      return;
    }

    print('All fields are filled');
    try {
      await _databaseService.addTask(_name!, _type!, _age!, _breed!,
          _photoPath!, _weight!, _healthStatus!);
      setState(() {
        _name = null;
        _type = null;
        _age = null;
        _breed = null;
        _photoPath = null;
        _weight = null;
        _healthStatus = null;
      });
      Navigator.pop(context);
      setState(() {}); // Refresh the task list
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addTaskButton(),
      body: _tasksList(),
      appBar: AppBar(
        title: const Center(child: Text('Evcil Hayvanlarım')),
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Center(child: Text("Evcil Hayvan Ekle")),
                titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            hintText: 'Evcil Hayvan Adı',
                            prefixIcon: const Icon(Icons.pets)),
                        maxLength: 20, // Limit the length of the input
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _type = value;
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            hintText: 'Evcil Hayvan Türü',
                            prefixIcon: const Icon(Icons.pets)),
                        maxLength: 20, // Limit the length of the input
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _age = int.tryParse(value);
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            hintText: 'Yaş',
                            prefixIcon: const Icon(Icons.cake)),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _breed = value;
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            hintText: 'Cinsiyet',
                            prefixIcon: const Icon(Icons.pets)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              onPressed: () async {
                                await _pickImage(ImageSource.gallery);
                                setState(() {});
                              },
                              icon: const Icon(Icons.photo),
                              label: const Text('Galeri'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                              onPressed: () async {
                                await _pickImage(ImageSource.camera);
                                setState(() {});
                              },
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Kamera'),
                            ),
                          ),
                        ],
                      ),
                      if (_photoPath != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(File(_photoPath!), height: 100),
                          ),
                        ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _weight = double.tryParse(value);
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            hintText: 'Ağırlık (kg)',
                            prefixIcon: const Icon(Icons.monitor_weight)),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _healthStatus = value;
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            hintText: 'Sağlık Durumu',
                            prefixIcon: const Icon(Icons.health_and_safety)),
                      ),
                      const SizedBox(height: 8),
                      MaterialButton(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onPressed: _addTask,
                        child: const Text(
                          'Ekle',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ).then((_) {
          // Reset the photo path when the dialog is closed
          setState(() {
            _photoPath = null;
          });
        });
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _tasksList() {
    return StreamBuilder<List<Task>>(
      stream: _databaseService.watchTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Henüz evcil hayvan eklenmedi.'));
        } else {
          print('Tasks displayed: ${snapshot.data!.length}');
          return ListView.builder(
            padding:
                const EdgeInsets.only(bottom: 80), // Alt kısma padding ekleyin
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              Task task = snapshot.data![index];
              print(
                  'Displaying task: ${task.name}, ${task.type}, ${task.age}, ${task.breed}, ${task.photoPath}, ${task.weight}, ${task.healthStatus}');
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: ListTile(
                  onLongPress: () async {
                    await _databaseService.deleteTask(task.id);
                    setState(() {});
                  },
                  leading: CircleAvatar(
                    backgroundImage: FileImage(File(task.photoPath)),
                    radius: 30,
                  ),
                  title: Text(
                    task.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tür: ${task.type}'),
                      Text('Yaş: ${task.age}'),
                      Text('Cinsiyet: ${task.breed}'),
                      Text('Ağırlık: ${task.weight} kg'),
                      Text('Sağlık Durumu: ${task.healthStatus}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _databaseService.deleteTask(task.id);
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
