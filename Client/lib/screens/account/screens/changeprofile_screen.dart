import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:good_to_go/components/app_bar.dart';
import 'package:good_to_go/components/base_filled_button.dart';
import 'package:good_to_go/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({Key? key}) : super(key: key);

  @override
  _ChangeProfileScreenState createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _image;
  String? _username;

  void _selectImage() async {
    print('_selectImage called');
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _handleImageUpload(File imageFile, String userId,
      String? displayName) async {
    print('_handleImageUpload called');
    try {
      final uri = Uri.parse(
          'http://34.64.188.192:8080/user/$userId');

      final request = http.MultipartRequest('PUT', uri);
      final photoMultipartFile = await http.MultipartFile.fromPath(
        'photoURL',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(photoMultipartFile);

      request.fields['data'] = json.encode({
        'displayName': displayName
      });

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final parsedJson = jsonDecode(responseBody);
        final photoURL = parsedJson['data']['photoURL'];

        print('responseBody: $responseBody');
        print('parsedJson: $parsedJson');
        print('photoURL to be saved: $photoURL');
        return photoURL;
      } else {
        return null;
      }
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }


  Future<bool> _handleChangeProfile(String? username, String? photoURL,
      User currentUser) async {
    print('_handleChangeProfile called');
    try {
      final uri =
      Uri.parse('http://34.64.188.192:8080/user/update');

      final response = await http.post(uri, body: {
        'uid': currentUser.uid,
        'displayName': username!,
        'photoURL': photoURL!
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error changing profile: $error');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: DefaultAppBar('프로필 수정'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top - 16 - 48 - 30 - 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _selectImage,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : userProvider.userPhotoURL != null
                          ? NetworkImage(userProvider.userPhotoURL!)
                          : const AssetImage(
                        'assets/icons/map/goody.png',
                      ) as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    initialValue: userProvider.userName,
                    decoration: InputDecoration(
                      labelText: '닉네임',
                      filled: true,
                      fillColor: Colors.white,
                      border: textFieldDefaultBorderStyle,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 18.h,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '닉네임을 입력하세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value;
                    },
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        margin: EdgeInsets.only(bottom: 30.h),
        child: BaseFilledButton(
          '수정하기',
              () async {
            print('BaseFilledButton pressed');

            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              // Upload image to storage if new image was selected
              final currentUser = userProvider.user!;
              String? photoURL;
              if (_image != null) {
                final userId = userProvider.user!.uid;
                photoURL = await _handleImageUpload(_image!, userId, _username);
                if (photoURL != null) {
                  print('photoURL to be saved: $photoURL');
                  userProvider.setUserPhotoURL(photoURL);
                  await currentUser.updatePhotoURL(photoURL);
                }
              }

              // Update user info in the provider
              if (_username != null) {
                userProvider.setUserName(_username!);
              }
              if (photoURL != null) {
                userProvider.setUserPhotoURL(photoURL);
              }

              // Update user info in Firebase Authentication
              final displayName =
                  userProvider.userName ?? currentUser.displayName;
              final updatedPhotoURL = photoURL ??
                  userProvider.userPhotoURL ??
                  currentUser.photoURL;
              await currentUser.updateDisplayName(displayName);
              await currentUser.updatePhotoURL(updatedPhotoURL);

              // Refresh user info in the provider
              final refreshedUser =
              await FirebaseAuth.instance.currentUser!;
              userProvider.setUser(refreshedUser);

              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

}