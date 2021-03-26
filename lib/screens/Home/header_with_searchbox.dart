import 'package:cooking_master/constants/color_constant.dart';
import 'package:cooking_master/constants/padding_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeaderWithSearchBox extends StatelessWidget {
  const HeaderWithSearchBox({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: defaultPadding * 2.5),
      height: size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              bottom: defaultPadding * 2,
            ),
            height: size.height * 0.2 - 27,
            decoration: BoxDecoration(
                color: blue2,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                )),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    //Todo: Add name user
                    Text(
                      AppLocalizations.of(context).hello + ' Huy,',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold,),
                    ),
                    Spacer(),
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage("assets/images/user.jpg")
                          )
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).askCook,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: defaultPadding),
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              height: 54,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50.0,
                      color: blue2.withOpacity(0.23),
                    )
                  ]),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).search,
                  hintStyle: TextStyle(
                    color: blue2.withOpacity(0.5),
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  suffixIcon: FaIcon(
                    FontAwesomeIcons.search,
                    color: blue2.withOpacity(0.5),
                  ),
                  suffixIconConstraints: BoxConstraints(
                    minHeight: 32,
                    minWidth: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}