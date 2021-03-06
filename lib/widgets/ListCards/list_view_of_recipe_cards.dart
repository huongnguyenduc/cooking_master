import 'dart:ui';
import 'package:cooking_master/constants/color_constant.dart';
import 'package:cooking_master/constants/padding_constant.dart';
import 'package:cooking_master/models/recipe_model.dart';
import 'package:cooking_master/screens/RecipeDetail/recipe_detail_screen.dart';
import 'package:cooking_master/screens/recipe_form/recipe_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:cooking_master/extension.dart';

class ListViewOfRecipeCards extends StatelessWidget {
  const ListViewOfRecipeCards(
      {Key key,
      @required this.cards,
      @required this.action,
      this.isEditing = false,
      @required this.parent,
      @required this.size})
      : super(key: key);

  final List<RecipeModel> cards;
  final Size size;
  final Widget action;
  final bool isEditing;
  final parent;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: defaultPadding * 0.6),
      height: size.height * 0.35,

      //List of recipe cards
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
              left: defaultPadding, right: defaultPadding * 0.4),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return action != null
                ? FocusedMenuHolder(
                    menuWidth: size.width * 0.5,
                    menuItems: [
                      if (isEditing)
                        FocusedMenuItem(
                            title: Text("Edit"),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return RecipeFormScreen(
                                      isUpdating: true,
                                      currentRecipe: cards[index],
                                    );
                                  },
                                ),
                              );
                            },
                            trailingIcon: Icon(Icons.edit_outlined)),
                      FocusedMenuItem(
                          title: Text("Delete"),
                          onPressed: () {
                            parent.setState(() {
                              cards.removeAt(index);
                              //cards.removeAt(index);
                              //db.mapSavedRecipe
                            });
                          },
                          trailingIcon: Icon(Icons.delete_outline)),
                    ],
                    blurBackgroundColor: Colors.grey[900],
                    menuOffset: 20,
                    openWithTap: false,
                    onPressed: () {},
                    duration: Duration(seconds: 0),
                    animateMenuItems: false,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                      recipe: cards[index],
                                    )));
                      },
                      child: Container(
                        width: size.width * 0.5,
                        height: size.width * 0.5,
                        margin: EdgeInsets.only(right: defaultPadding * 0.7),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: blue2.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: cards[index].image != null
                                  ? NetworkImage(cards[index].image)
                                  : AssetImage("assets/images/recipe2.jpg"),
                            )),
                        child: Stack(
                          children: [
                            //Kind of recipe
                            Positioned(
                              top: defaultPadding,
                              left: defaultPadding,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaY: 19.2,
                                    sigmaX: 19.2,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: defaultPadding * 0.5,
                                        right: defaultPadding * 0.5,
                                        top: defaultPadding * 0.2,
                                        bottom: defaultPadding * 0.2),
                                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                    child: Text(
                                      cards[index]
                                          .category
                                          .capitalizeFirstofEach,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.5,
                            ),
                            //Detail Information
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.all(defaultPadding * 0.45),
                                margin: EdgeInsets.only(bottom: defaultPadding),
                                width: size.width * 0.45,
                                height: size.height * 0.35 * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                child: Stack(
                                  children: [
                                    //Recipe Name
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        width: size.width * 0.8 * 0.6,
                                        height: size.height * 0.35 * 0.3 * 0.7,
                                        child: Text(
                                          cards[index].name.length > 40 ? cards[index].name.replaceRange(cards[index].name.substring(0, 40).lastIndexOf(" "), cards[index].name.length, "...") : cards[index].name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    //Time & Serving
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        cards[index].cookTime.toString() + " mins" +
                                            ' | ' +
                                            cards[index].yields.toString() +
                                            " " +
                                            (cards[index].yields > 1 ? "servings" : "serving"),
                                        style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            cards[index].isSelected
                                ? Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                    recipe: cards[index],
                                  )));
                    },
                    child: Container(
                      width: size.width * 0.5,
                      height: size.width * 0.5,
                      margin: EdgeInsets.only(right: defaultPadding * 0.7),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: blue2.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: cards[index].image != null
                                ? NetworkImage(cards[index].image)
                                : AssetImage("assets/images/recipe2.jpg"),
                          )),
                      child: Stack(
                        children: [
                          //Kind of recipe
                          Positioned(
                            top: defaultPadding,
                            left: defaultPadding,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaY: 19.2,
                                  sigmaX: 19.2,
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: defaultPadding * 0.5,
                                      right: defaultPadding * 0.5,
                                      top: defaultPadding * 0.2,
                                      bottom: defaultPadding * 0.2),
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
                                  child: Text(
                                    cards[index].category.capitalizeFirstofEach,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.5,
                          ),
                          //Detail Information
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding * 0.45),
                              margin: EdgeInsets.only(bottom: defaultPadding),
                              width: size.width * 0.45,
                              height: size.height * 0.35 * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.black.withOpacity(0.7),
                              ),
                              child: Stack(
                                children: [
                                  //Recipe Name
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: size.width * 0.8 * 0.6,
                                      height: size.height * 0.35 * 0.3 * 0.7,
                                      child: Text(
                                        cards[index].name.length > 40 ? cards[index].name.replaceRange(cards[index].name.substring(0, 40).lastIndexOf(" "), cards[index].name.length, "...") : cards[index].name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  //Time & Serving
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      cards[index].cookTime.toString() +
                                          ' mins | ' +
                                          cards[index].yields.toString() +
                                          (cards[index].yields > 1 ? " servings" : " serving"), // +
                                      //  AppLocalizations.of(context).serving?? '',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.7), fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
          }),
    );
  }
}
