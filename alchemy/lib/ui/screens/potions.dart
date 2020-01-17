import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/screens/potionSearch.dart';
import 'package:alchemy/ui/values/strings.dart';
import 'package:alchemy/ui/widgets/effect_info.dart';
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
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ILine(type: "2"),
                ILine(type: "3"),
                ILine(type: "4")
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ILine(type: "1"),
                    ILine(type: "1"),
                    ILine(type: "1")
                  ],
                ),
                Stack(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        homeViewModel.potionIngredients[0] == null
                            ? IngredientSquare(slot: 1)
                            : ChosenIngredientSquare(slot: 1),
                        homeViewModel.potionIngredients[1] == null
                            ? IngredientSquare(slot: 2)
                            : ChosenIngredientSquare(slot: 2),
                        homeViewModel.potionIngredients[2] == null
                            ? IngredientSquare(slot: 3)
                            : ChosenIngredientSquare(slot: 3),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ButtonSquare(slot: 1),
                        ButtonSquare(slot: 2),
                        ButtonSquare(slot: 3),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Text(
                            "Results (${homeViewModel.possiblePotions.length})",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        homeViewModel.possiblePotions.isEmpty
                            ? Container()
                            : Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Divider(
                                    color: Colors.black,
                                    height: 1,
                                  ),
                                  itemCount:
                                      homeViewModel.possiblePotions.length,
                                  itemBuilder: (BuildContext context, int i) =>
                                      FlatButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          homeViewModel
                                              .possiblePotions[i][0].title,
                                          style:
                                              Theme.of(context).textTheme.body1,
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            " " +
                                                homeViewModel.possiblePotions[i]
                                                    [1],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      homeViewModel.changeItem2(
                                          homeViewModel.possiblePotions[i][0]);
                                      homeViewModel.nulifyCurrentInfo2();
                                      homeViewModel.getInfoE(EFEITO_URL +
                                          homeViewModel.currentEffect.url);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EffectInfo(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            RemoveIngredientButton(slot: 1),
            RemoveIngredientButton(slot: 2),
            RemoveIngredientButton(slot: 3),
          ],
        ),
      ),
    );
  }
}

class RemoveIngredientButton extends StatelessWidget {
  final int slot;
  RemoveIngredientButton({@required this.slot});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return homeViewModel.potionIngredients[slot - 1] == null
        ? Container()
        : Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.297,
              left: MediaQuery.of(context).size.width *
                  (slot == 1 ? 0.19 : slot == 2 ? 0.508 : 0.827),
            ),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                homeViewModel.updatePotionIngredients(slot, null);
                homeViewModel.updatePossiblePotions();
              },
            ),
          );
  }
}

class ChosenIngredientSquare extends StatelessWidget {
  final int slot;
  ChosenIngredientSquare({@required this.slot});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            "assets/ingredients/${homeViewModel.potionIngredients[slot - 1].title.replaceAll(" ", "")}.png",
            scale: 2.5,
          ),
          Text(
            slot == 1
                ? homeViewModel.potionIngredients[0].title
                : slot == 2
                    ? homeViewModel.potionIngredients[1].title
                    : homeViewModel.potionIngredients[2].title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14 / MediaQuery.of(context).textScaleFactor,
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonSquare extends StatelessWidget {
  final int slot;
  ButtonSquare({@required this.slot});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: MediaQuery.of(context).size.width * 0.25,
        width: MediaQuery.of(context).size.width * 0.179,
      ),
      onPressed: () => showSearch(
        context: context,
        delegate: PotionSearchScreen(slot: slot),
      ),
    );
  }
}

class IngredientSquare extends StatelessWidget {
  final int slot;
  IngredientSquare({@required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Choose Ingredient",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            slot == 1 || slot == 2 ? "*required" : "*optional",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class TLine extends StatelessWidget {
  final String type;
  TLine({@required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * (type == "1" ? 0.07 : 0.071),
      width: MediaQuery.of(context).size.width * 0.1312,
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
  final String type;
  ILine({@required this.type});

  @override
  Widget build(BuildContext context) {
    return type == "1"
        ? Container(
            height: 20,
            width: 2,
            color: Theme.of(context).iconTheme.color,
          )
        : Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
            width: MediaQuery.of(context).size.width * 0.25,
            height: MediaQuery.of(context).size.width * 0.25,
            color: Colors.transparent,
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: type == "3"
                            ? Colors.transparent
                            : Theme.of(context).iconTheme.color,
                        width: 1,
                      ),
                      top: BorderSide(
                        color: type == "3" || type == "2"
                            ? Colors.transparent
                            : Theme.of(context).iconTheme.color,
                        width: 2,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.125,
                  height: MediaQuery.of(context).size.width * 0.25,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: type == "3"
                                ? Colors.transparent
                                : Theme.of(context).iconTheme.color,
                            width: 1),
                        top: BorderSide(
                            color: type == "3" || type == "4"
                                ? Colors.transparent
                                : Theme.of(context).iconTheme.color,
                            width: 2)),
                  ),
                  width: MediaQuery.of(context).size.width * 0.125,
                  height: MediaQuery.of(context).size.width * 0.25,
                ),
              ],
            ),
          );
    ;
  }
}
