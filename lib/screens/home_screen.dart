import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_tracking_app/services/database_service.dart';
import '../models/task.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'feeding_tracker_screen.dart';
import 'feeding_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  void _addTask() async {
    if (!_formKey.currentState!.validate()) {
      return; // If the form is not valid, do not proceed
    }

    if (_photoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir fotoğraf ekleyin!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tüm alanları doldurun!'),
          duration: Duration(seconds: 2),
        ),
      );
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
      // ignore: empty_catches
    } catch (e) {}
  }

  void _showPetDetails(Task pet) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              pet.name[0].toUpperCase() + pet.name.substring(1),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(pet.photoPath),
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    const Text(
                      'Tür: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      pet.type,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cake, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Yaş: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${pet.age}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pets, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Cinsiyet: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      pet.breed,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monitor_weight, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Ağırlık: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${pet.weight} kg',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.health_and_safety, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Sağlık Durumu: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      pet.healthStatus,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Kapat',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _databaseService.deleteTask(pet.id);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Sil',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addTaskButton(),
      body: _tasksList(),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Evcil Hayvanlarım',
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _name = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintText: 'Evcil Hayvan Adı',
                            prefixIcon: const Icon(Icons.pets),
                            counterText: '${_name?.length ?? 0}/20',
                          ),
                          maxLength: 20, // Limit the length of the input
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Evcil Hayvan Adı boş olamaz!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _type = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintText: 'Evcil Hayvan Türü',
                            prefixIcon: const Icon(Icons.pets),
                            counterText: '${_type?.length ?? 0}/20',
                          ),
                          maxLength: 20, // Limit the length of the input
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Evcil Hayvan Türü boş olamaz!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _age = int.tryParse(value);
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintText: 'Yaş',
                            prefixIcon: const Icon(Icons.cake),
                          ),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Yaş boş olamaz!';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Yaş geçerli bir sayı olmalıdır!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _breed = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintText: 'Cinsiyet',
                            prefixIcon: const Icon(Icons.pets),
                          ),
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cinsiyet boş olamaz!';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(
                                r'[a-zA-Z\s]')), // Allow only letters and spaces
                          ],
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
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _weight = double.tryParse(value);
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintText: 'Ağırlık (kg)',
                            prefixIcon: const Icon(Icons.monitor_weight),
                          ),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ağırlık boş olamaz!';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Ağırlık geçerli bir sayı olmalıdır!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _healthStatus = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintText: 'Sağlık Durumu',
                            prefixIcon: const Icon(Icons.health_and_safety),
                          ),
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Sağlık Durumu boş olamaz!';
                            }
                            return null;
                          },
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
      child: const Icon(Icons.pets),
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
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              Task task = snapshot.data![index];
              print(
                  'Displaying task: ${task.name}, ${task.type}, ${task.age}, ${task.breed}, ${task.photoPath}, ${task.weight}, ${task.healthStatus}');
              return GestureDetector(
                onTap: () {
                  _showPetDetails(task);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.file(
                          File(task.photoPath),
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 8),
                                Text(
                                  task.name[0].toUpperCase() +
                                      task.name.substring(1),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 8),
                                Text(
                                  'Tür: ${task.type}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 8),
                                Text(
                                  'Cinsiyet: ${task.breed}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
