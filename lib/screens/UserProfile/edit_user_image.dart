import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cooking_master/services/auth_service.dart';
import 'package:cooking_master/constants/color_constant.dart';
import 'package:cooking_master/services/firebase_storage.dart';
import 'package:cooking_master/services/userprofile_service.dart';
import 'package:cooking_master/widgets/CustomBackButton.dart';
import 'package:cooking_master/widgets/appbar.dart';
import 'package:cooking_master/widgets/show_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditUserImage extends StatefulWidget {
  const EditUserImage({Key key, this.imageurl}) : super(key: key);
  final imageurl;
  _EditUserImageState createState() => _EditUserImageState();
}

class _EditUserImageState extends State<EditUserImage> {
  File _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: buildAppBar(context, title: '', actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.black,
            ),
            onPressed: () => _confirmUpdate(context),
          ),
        ], leading: CustomBackButton(
          tapEvent: () {
            Navigator.pop(context);
          },
        )),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Avatar",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: getImage,
                  child: Text(
                    "Gallery",
                    style: GoogleFonts.roboto(
                        color: blue3,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Hero(
                tag: "avatar",
                child: Container(
                    width: 160,
                    height: 160,
                    child: CircleAvatar(
                      backgroundImage: _image == null
                          ? NetworkImage(widget.imageurl)
                          : FileImage(_image),
                    )),
              ),
            ),
          ],
        ));
  }

  Future<void> getImage() async {
    // ignore: invalid_use_of_visible_for_testing_member
    final pickedFile = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 400,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _confirmUpdate(BuildContext context) async {
    final userStorage = Provider.of<StorageRepo>(context, listen: false);
    final userProfile = Provider.of<UserProfileService>(context, listen: false);
    final user = Provider.of<AuthBase>(context, listen: false);

    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Save change',
      content: 'Are you sure that you want to save change?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Save',
    );

    if (didRequestSignOut == true) {
      final cloudinary =
          CloudinaryPublic('huong', 'wedding', cache: true);
      //var imageurl = await userStorage.uploadFile(_image, user.currentUser.uid);
      try {
        CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(_image.path,
                resourceType: CloudinaryResourceType.Image),
            );
        print(response.secureUrl);
        if (response.secureUrl != null)
          await userProfile.updateUser(
              user.currentUser.uid, 'imageurl', response.secureUrl);
        Navigator.pop(context, true);
      } on CloudinaryException catch (e) {
        print(e.message);
        print(e.request);
      }
    }
  }
}
