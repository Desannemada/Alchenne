import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/information/measure.dart';
import 'package:alchemy/ui/values/strings.dart';
import 'package:alchemy/ui/widgets/ingred_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientItem extends StatelessWidget {
  IngredientItem({
    @required this.index,
    @required this.key,
  });

  final int index;
  final GlobalKey key;

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return MeasureSize(
      onChange: (size) {
        homeViewModel.updateContainerHeight(size.height);
      },
      child: Container(
        // key: !homeViewModel.aux  ? key : null,
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: homeViewModel.favIngredientes.contains(index)
                          ? homeViewModel.colors[homeViewModel
                              .favIColors[homeViewModel.getColor(index)]]
                          : Colors.black38,
                      width: 2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 14),
                elevation: 30,
                color: Theme.of(context).canvasColor.withOpacity(0.78),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: CircleAvatar(
                          radius: 40,
                          child: Image.asset(
                            "assets/ingredients/${homeViewModel.ingredientes[index].title.replaceAll(" ", "")}.png",
                            fit: BoxFit.contain,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Image.asset("assets/quill.webp"),
                                  SizedBox(width: 2),
                                  Text(
                                    homeViewModel.ingredientes[index].weight,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045 /
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/coin.png",
                                    scale: 10,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    homeViewModel.ingredientes[index].value,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045 /
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            homeViewModel.ingredientes[index].title,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width *
                                  0.044 /
                                  MediaQuery.of(context).textScaleFactor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              child: FlatButton(
                child: Container(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                ),
                onLongPress: () {
                  if (!homeViewModel.favIngredientes.contains(index)) {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        backgroundColor: Color(0xFF262b2f),
                        title: Text("Choose category"),
                        actions: [
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              children: List.generate(
                                homeViewModel.colors.length,
                                (color) => RaisedButton(
                                  onPressed: () {
                                    homeViewModel.updateIFavList(index, color);
                                    Navigator.of(context).pop();
                                  },
                                  shape: CircleBorder(),
                                  color: homeViewModel.colors[color],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    homeViewModel.updateIFavList(index, null);
                  }
                },
                onPressed: () {
                  homeViewModel.changeItem(homeViewModel.ingredientes[index]);
                  homeViewModel.nulifyCurrentInfo();
                  homeViewModel.fecharInfos();
                  homeViewModel.getInfoI(
                      INGREDIENT_URL + homeViewModel.currentIngredient.url);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IngredientInfo(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
