// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pet_tracking_app/models/database_helper.dart';
// import 'package:pet_tracking_app/models/pet.dart';
// import 'dart:io';

// class AddPetScreen extends StatefulWidget {
//   const AddPetScreen({super.key});

//   @override
//   _AddPetScreenState createState() => _AddPetScreenState();
// }

// class _AddPetScreenState extends State<AddPetScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _typeController = TextEditingController();
//   final _ageController = TextEditingController();
//   final _breedController = TextEditingController();
//   final _weightController = TextEditingController();
//   final _healthStatusController = TextEditingController();
//   DateTime? _lastVetVisit;
//   final List<String> _vaccinations = [];
//   String? _photoPath;

//   void _pickPhoto() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _photoPath = pickedFile.path;
//       });
//     }
//   }

//   Future<void> _savePet() async {
//     if (_formKey.currentState!.validate()) {
//       final pet = Pet(
//         name: _nameController.text,
//         type: _typeController.text,
//         age: int.parse(_ageController.text),
//         breed: _breedController.text,
//         photoPath: _photoPath ?? '',
//         weight: double.parse(_weightController.text),
//         healthStatus: _healthStatusController.text,
//         lastVetVisit: _lastVetVisit ?? DateTime.now(),
//         vaccinations: _vaccinations,
//       );
//       try {
//         await DatabaseHelper.instance.insertPet(pet);
//         Navigator.pop(context);
//       } catch (e) {
//         print('Error saving pet: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Evcil Hayvan Ekle')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Adı'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Lütfen bir ad girin';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _typeController,
//                 decoration: const InputDecoration(labelText: 'Türü'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Lütfen bir tür girin';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _ageController,
//                 decoration: const InputDecoration(labelText: 'Yaşı'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Lütfen bir yaş girin';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _breedController,
//                 decoration: const InputDecoration(labelText: 'Cinsi'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Lütfen bir cins girin';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _weightController,
//                 decoration: const InputDecoration(labelText: 'Ağırlık'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Lütfen bir ağırlık girin';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _healthStatusController,
//                 decoration: const InputDecoration(labelText: 'Sağlık Durumu'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Lütfen bir sağlık durumu girin';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _pickPhoto,
//                 child: const Text('Fotoğraf Seç'),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _savePet,
//                 child: const Text('Kaydet'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
