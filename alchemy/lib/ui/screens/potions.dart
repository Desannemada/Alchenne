import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PotionTab extends StatelessWidget {
  const PotionTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: homeViewModel.currentBackground[0][2],
          alignment: Alignment.center,
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TLine(type: "1"),
                Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        "assets/flask.png",
                        scale: 1.9,
                      ),
                      Text("Potion Maker")
                    ],
                  ),
                ),
                TLine(type: "2"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[ILine(), ILine(), ILine()],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IngredientSquare(),
                IngredientSquare(),
                IngredientSquare(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TLine extends StatelessWidget {
  String type = "";
  TLine({this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (type == "1" ? 0.07 : 0.071),
      width: MediaQuery.of(context).size.height * (type == "1" ? 0.07 : 0.071),
      decoration: BoxDecoration(
        border: type == "1"
            ? Border(
                left: BorderSide(
                  color: Theme.of(context).iconTheme.color,
                  width: 2,
                ),
                top: BorderSide(
                  color: Theme.of(context).iconTheme.color,
                  width: 2,
                ),
              )
            : Border(
                right: BorderSide(
                  color: Theme.of(context).iconTheme.color,
                  width: 2,
                ),
                top: BorderSide(
                  color: Theme.of(context).iconTheme.color,
                  width: 2,
                ),
              ),
      ),
    );
  }
}

class ILine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 2,
      color: Theme.of(context).iconTheme.color,
    );
  }
}

class IngredientSquare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          "Choose Ingredient",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
      onPressed: () {},
    );
  }
}
