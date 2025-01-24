import 'package:flutter/material.dart';
import 'package:pet_tracking_app/services/database_service.dart';

import '../models/task.dart';
// import 'pet_list_screen.dart';
// import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;

  String? _task = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addTaskButton(),
      body: _tasksList(),
      appBar: AppBar(title: const Text('Ana Sayfa')),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Add Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _task = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Evcil Hayvan Adı',
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if (_task == null || _task == "") return;
                    _databaseService.addTask(_task!);
                    setState(() {
                      _task = null;
                    });
                    Navigator.pop(
                      context,
                    );
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
        // _databaseService.addTask('Yeni Görev');
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _tasksList() {
    return FutureBuilder(
      future: _databaseService.getTask(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            Task task = snapshot.data![index];
            return ListTile(
              onLongPress: () {
                _databaseService.deleteTask(
                  task.id,
                );
                setState(() {});
              },
              title: Text(
                task.content,
              ),
              // trailing: Checkbox(
              //   value: false,
              //   onChanged: (value) {},
              // ),
            );
          },
        );
      },
    );
  }
}
