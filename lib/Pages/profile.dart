import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      user = currentUser;
    });
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
      });
      await _uploadImage(imageFile);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      // Define a unique path for the image
      String filePath = 'profile_images/${user?.uid}.png';

      // Upload the image to Firebase Storage
      await FirebaseStorage.instance.ref(filePath).putFile(imageFile);

      // Get the download URL of the uploaded image
      String downloadURL = await FirebaseStorage.instance.ref(filePath).getDownloadURL();

      // Update the user's profile with the new image URL
      await user?.updatePhotoURL(downloadURL);

      // Reload the user to update the profile information
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      // Update the UI
      setState(() {});
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : NetworkImage(user?.photoURL ?? 'https://via.placeholder.com/150') as ImageProvider<Object>?,
            ),
            const SizedBox(height: 20),
            Text(
              user?.displayName ?? 'Anonymous',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user?.email ?? 'No email',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getImage();
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
