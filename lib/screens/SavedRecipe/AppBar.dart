//import 'package:cooking_master/models/model-recipe-cuahuy.dart';
import 'dart:ffi';

import 'package:cooking_master/models/recipe_card_model.dart';
import 'package:cooking_master/notifier/user_saved_recipe.dart';
import 'package:cooking_master/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../user_profile_screen.dart';
import 'package:cooking_master/screens/saved_recipe_screen.dart';

buildAddCategoryButton(BuildContext context, TabController _tabController,
    TextEditingController _categoryController) {
  String alertTitle;
  switch (_tabController.index) {
    case 2:
      alertTitle = "New Favorite Topic";
      break;
    default:
      alertTitle = "New Category";
      break;
  }
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(alertTitle),
          content: TextField(
            controller: _categoryController,
          ),
          actions: [
            MaterialButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(_categoryController.text.toString());
                },
                child: Text("Submit"))
          ],
        );
      });
}

AppBar buildSavedRecipeAppBar(
    BuildContext context,
    TabController _tabController,
    TextEditingController _categoryController,
    SavedRecipeScreenState parent) {
  final savedRecipe = Provider.of<SavedRecipeProvider>(context, listen: false);
  return buildAppBar(
    context,
    //Todo: Add username here
    title: "Minh Huy Bui",
    actions: !parent.isEditing
        ? [
            IconButton(
              icon: Icon(
                Icons.insights_outlined,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.library_add_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                buildAddCategoryButton(
                    context, _tabController, _categoryController);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ]
        : [
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.black,
              ),
              onPressed: () {
                parent.setState(() {
                  parent.isEditing = false;
                  savedRecipe.removeRecipe();
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.black,
              ),
              onPressed: () {
                parent.setState(() {
                  parent.isEditing = false;
                  savedRecipe.setUnselected();
                });
              },
            ),
          ],
    leading: GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserProfileScreen()));
      },
      child: Hero(
          tag: 'avatar',
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/user.jpg"),
            ),
          )),
    ),
    bottom: TabBar(
      controller: _tabController,
      tabs: [
        Tab(
            child: Text(
          "Saved",
          style: GoogleFonts.roboto(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        )),
        Tab(
            child: Text(
          "Your recipe",
          style: GoogleFonts.roboto(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        )),
        Tab(
            child: Text(
          "Favorite Topic",
          style: GoogleFonts.roboto(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ))
      ],
    ),
  );
}