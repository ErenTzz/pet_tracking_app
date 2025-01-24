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
  String? _photoPath;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addTaskButton(),
      body: _tasksList(),
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Evcil Hayvan Ekle"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Evcil Hayvan Adı',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _type = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Evcil Hayvan Türü',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: const Text('Galeriden Seç'),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: const Text('Kamerayla Çek'),
                    ),
                  ],
                ),
                if (_photoPath != null)
                  Image.file(File(_photoPath!), height: 100),
                const SizedBox(height: 8),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (_name == null ||
                        _name!.isEmpty ||
                        _type == null ||
                        _type!.isEmpty ||
                        _photoPath == null) {
                      return;
                    }
                    _databaseService.addTask(_name!, _type!, _photoPath!);
                    setState(() {
                      _name = null;
                      _type = null;
                      _photoPath = null;
                    });
                    Navigator.pop(context);
                  },
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
      child: const Icon(Icons.add),
    );
  }

  Widget _tasksList() {
    return FutureBuilder(
      future: _databaseService.getTask(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Henüz evcil hayvan eklenmedi.'));
        } else {
          // print('Tasks displayed: ${snapshot.data!.length}');
          return ListView.builder(
            padding:
                const EdgeInsets.only(bottom: 80), // Alt kısma padding ekleyin
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              Task task = snapshot.data![index];
              // print(
              //     'Displaying task: ${task.content}, ${task.type}, ${task.photoPath}');
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  onLongPress: () {
                    _databaseService.deleteTask(task.id);
                    setState(() {});
                  },
                  leading: CircleAvatar(
                    backgroundImage: FileImage(File(task.photoPath)),
                    radius: 30,
                  ),
                  title: Text(
                    task.content,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Tür: ${task.type}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _databaseService.deleteTask(task.id);
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
