import 'package:alchemy/ui/widgets/draggable_scrollbar.dart';
import 'package:alchemy/ui/widgets/item_efeito.dart';
import 'package:alchemy/ui/widgets/item_ingredient.dart';
import 'package:flutter/material.dart';

import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:provider/provider.dart';

class FavouritesTab extends StatefulWidget {
  @override
  _FavouritesTabState createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<FavouritesTab> {
  ScrollController eController = new ScrollController();
  ScrollController iController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    // if (homeViewModel.ingredientes.isEmpty) {
    //   Future.delayed(Duration(seconds: 5), () {
    //     showDialog(
    //         context: context,
    //         builder: (BuildContext context) => AlertDialog(
    //               elevation: 10,
    //               content: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: <Widget>[
    //                   Text(
    //                     "Erro de Conexão >.<",
    //                     textAlign: TextAlign.center,
    //                   ),
    //                   FlatButton(
    //                     child: Text("Refresh"),
    //                     onPressed: () {
    //                       // print(info.ingredientes);
    //                       homeViewModel.refresh();
    //                       Navigator.of(context).pop();
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ));
    //   });
    // }

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: homeViewModel.currentBackground[0][0],
              alignment: Alignment.centerLeft,
              fit: BoxFit.fill,
            ),
          ),
        ),
        homeViewModel.ingredientes.isEmpty
            ? Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).textTheme.bodyText2.color),
                  ),
                ),
              )
            : Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black54,
                    ),
                    width: MediaQuery.of(context).size.width * 0.04,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        26,
                        (index) {
                          String aux;
                          ScrollController c;
                          if (homeViewModel.currentFav) {
                            aux = "favIngrediente";
                            c = iController;
                          } else if (!homeViewModel.currentFav) {
                            aux = "favEfeito";
                            c = eController;
                          }
                          return GestureDetector(
                            onTap: () {
                              homeViewModel.getPosition(index, aux, c);
                            },
                            onVerticalDragUpdate: (DragUpdateDetails detail) {
                              var pos = detail.globalPosition.dy.toInt();
                              for (var i = 0; i < 26; i++) {
                                var start = 128 + (i * 23);
                                var end = start + 23;
                                if (pos >= start && pos <= end) {
                                  if (!homeViewModel.currentFav &&
                                      homeViewModel
                                              .currentPositionOnAlphabetScroll3 !=
                                          i) {
                                    homeViewModel.getPosition(i, aux, c);
                                  }
                                  if (homeViewModel.currentFav &&
                                      homeViewModel
                                              .currentPositionOnAlphabetScroll4 !=
                                          i) {
                                    homeViewModel.getPosition(i, aux, c);
                                  }
                                }
                              }
                            },
                            onLongPress: () {
                              homeViewModel.getPosition(index, aux, c);
                            },
                            child: Container(
                              child: Text(
                                homeViewModel.isLetter(
                                        String.fromCharCode(65 + index), aux)
                                    ? String.fromCharCode(65 + index)
                                    : "-",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: (MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.0245) /
                                      MediaQuery.of(context).textScaleFactor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      (homeViewModel.currentFav &&
                                  homeViewModel.favIngredientes.isEmpty) ||
                              (!homeViewModel.currentFav &&
                                  homeViewModel.favEfeitos.isEmpty)
                          ? Container(
                              child: Text(
                                homeViewModel.currentFav
                                    ? "No favourite ingredients. \nHold to favourite."
                                    : "No favourite effects. \nHold to favourite.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: homeViewModel.bgColor
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .color
                                      : Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(bottom: 50),
                              width: MediaQuery.of(context).size.width * 0.96,
                              child: DraggableScrollbar.arrows(
                                backgroundColor:
                                    Theme.of(context).textTheme.bodyText2.color,
                                controller: homeViewModel.currentFav
                                    ? iController
                                    : eController,
                                child: GridView.count(
                                  childAspectRatio: 0.99,
                                  controller: homeViewModel.currentFav
                                      ? iController
                                      : eController,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  mainAxisSpacing: 20,
                                  crossAxisCount: 2,
                                  children: List.generate(
                                      homeViewModel.currentFav
                                          ? homeViewModel.favIngredientes.length
                                          : homeViewModel.favEfeitos.length,
                                      (int index) {
                                    return homeViewModel.currentFav
                                        ? IngredientItem(
                                            index: homeViewModel
                                                .favIngredientes[index],
                                            key: index == 0
                                                ? homeViewModel.sizeC4
                                                : null,
                                          )
                                        : EffectItem(
                                            index:
                                                homeViewModel.favEfeitos[index],
                                            key: index == 0
                                                ? homeViewModel.sizeC3
                                                : null,
                                          );
                                  }),
                                ),
                              ),
                            ),
                      AnimatedOpacity(
                        opacity: homeViewModel.alphabetBubble == "" ? 0.0 : 1.0,
                        duration: Duration(seconds: 1),
                        onEnd: () {
                          homeViewModel.changeBubble("");
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          child: Card(
                            elevation: 1.5,
                            color: Colors.black38,
                            child: Center(
                                child: Text(
                              homeViewModel.alphabetBubble,
                              style: TextStyle(fontSize: 40),
                            )),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            children: List.generate(
                              2,
                              (index) => Expanded(
                                child: Align(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.48,
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    color: (homeViewModel.currentFav &&
                                                index == 1) ||
                                            (!homeViewModel.currentFav &&
                                                index == 0)
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .color
                                        : Theme.of(context).primaryColor,
                                    child: FlatButton(
                                      onPressed: () {
                                        if (index == 0) {
                                          homeViewModel.updateCurrentFav(false);
                                        } else if (index == 1) {
                                          homeViewModel.updateCurrentFav(true);
                                        }
                                      },
                                      child: Text(
                                        index == 0
                                            ? "My Effects"
                                            : "My Ingredients",
                                        style: TextStyle(
                                          color: (homeViewModel.currentFav &&
                                                      index == 1) ||
                                                  (!homeViewModel.currentFav &&
                                                      index == 0)
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .color,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ],
    );
  }
}
