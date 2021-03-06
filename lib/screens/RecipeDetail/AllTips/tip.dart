import 'package:cooking_master/models/recipe_model.dart';
import 'package:cooking_master/models/tip_model.dart';
import 'package:cooking_master/models/user_model.dart';
import 'package:cooking_master/screens/RecipeDetail/AllTips/tip_like.dart';
import 'package:cooking_master/screens/UserProfileWatch/user_profile_watch_screen.dart';
import 'package:cooking_master/services/userprofile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Tip extends StatefulWidget {
  final RecipeModel recipe;
  final TipModel tip;

  const Tip({
    Key key,
    @required this.recipe,
    @required this.tip,
  }) : super(key: key);

  @override
  _TipState createState() => _TipState();
}

class _TipState extends State<Tip> {
  @override
  Widget build(BuildContext context) {
    final userProfileService = Provider.of<UserProfileService>(context);

    return StreamBuilder<UserModel>(
      stream: userProfileService.loadProfile(widget.tip.owner),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return GestureDetector(
            onTap: () {
              if (widget.tip.owner != FirebaseAuth.instance.currentUser.uid) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserProfileWatchScreen(uid: widget.tip.owner)));
              }
            },
            child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 15, right: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data.userImage)),
                  ),
                  Expanded(
                      flex: 8,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.userName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 5),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: widget.tip.image != null
                                    ? Image.network(
                                        widget.tip.image,
                                        fit: BoxFit.fitWidth,
                                      )
                                    : SizedBox()),
                            SizedBox(height: 5),
                            Text(
                              widget.tip.content,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 18),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  timeago.format(DateTime.now().subtract(
                                      DateTime.now().difference(
                                          widget.tip.createdAt.toDate()))),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14),
                                ),
                                TipLike(recipe: widget.recipe, tip: widget.tip),
                              ],
                            )
                          ]))
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
