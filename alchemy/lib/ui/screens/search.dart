import 'package:alchemy/core/models/efeitos.dart';
import 'package:alchemy/core/models/ingredientes.dart';
import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/widgets/effect_info.dart';
import 'package:alchemy/ui/widgets/ingred_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends SearchDelegate {
  final List bgs;
  SearchScreen(this.bgs);

  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Theme.of(context).primaryColor,
      primaryIconTheme: Theme.of(context).iconTheme,
      primaryTextTheme: Theme.of(context).textTheme,
      cursorColor: Theme.of(context).cursorColor,
      inputDecorationTheme: Theme.of(context).inputDecorationTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    List results = [""];
    for (var item in homeViewModel.ingredientsEffects) {
      if (item.title.toUpperCase().contains(query.toUpperCase())) {
        results.add(item);
      }
    }
    return query == ""
        ? homeViewModel.recentes.isEmpty
            ? Center(
                child: Text(
                  "Search for ingredients and effects",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width *
                        0.05 /
                        MediaQuery.of(context).textScaleFactor,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(10),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    color: Colors.black,
                    height: MediaQuery.of(context).size.height * 0.003,
                  ),
                  itemCount: homeViewModel.recentes.length + 1,
                  itemBuilder: (BuildContext context, int i) {
                    var item;
                    if (i != 0) {
                      if (homeViewModel.recentes[i - 1][1] == 0) {
                        item = homeViewModel
                            .ingredientes[homeViewModel.recentes[i - 1][0]];
                      } else if (homeViewModel.recentes[i - 1][1] == 1) {
                        item = homeViewModel
                            .efeitos[homeViewModel.recentes[i - 1][0]];
                      }
                    }

                    return i == 0
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Opacity(
                              opacity: 0.7,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 34,
                                    child: FlatButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () =>
                                          homeViewModel.clearRecentes(),
                                      child: Text(
                                        "clear all",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05 /
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "recent searches",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05 /
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: FlatButton(
                                  child: Text(
                                    item.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .color,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05 /
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (item is Ingredientes) {
                                      homeViewModel.changeItem(item);
                                      homeViewModel.updateRecentes(item, true);
                                      homeViewModel.nulifyCurrentInfo();
                                      homeViewModel.fecharInfos();
                                      homeViewModel.getInfoI(item.title);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              IngredientInfo(bgs),
                                        ),
                                      );
                                    } else if (item is Efeitos) {
                                      homeViewModel.changeItem2(item);
                                      homeViewModel.updateRecentes(item, true);
                                      homeViewModel.nulifyCurrentInfo2();
                                      homeViewModel.getInfoE(item.title);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EffectInfo(bgs),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.clear),
                                iconSize: 22,
                                color: Colors.black,
                                onPressed: (() =>
                                    homeViewModel.updateRecentes(item, false)),
                              )
                            ],
                          );
                  },
                ),
              )
        : Padding(
            padding: EdgeInsets.all(10),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.003,
              ),
              itemCount: results.length + 1,
              itemBuilder: (BuildContext context, int i) => i == 0
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Opacity(
                        opacity: 0.7,
                        child: Text(
                          (results.length - 1).toString() + " results",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width *
                                0.05 /
                                MediaQuery.of(context).textScaleFactor,
                          ),
                        ),
                      ),
                    )
                  : i == results.length
                      ? Text("")
                      : FlatButton(
                          child: Text(
                            results[i].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                              fontSize: MediaQuery.of(context).size.width *
                                  0.05 /
                                  MediaQuery.of(context).textScaleFactor,
                            ),
                          ),
                          onPressed: () {
                            if (results[i] is Ingredientes) {
                              // print(results[i].title);
                              homeViewModel.changeItem(results[i]);
                              homeViewModel.updateRecentes(results[i], true);
                              homeViewModel.nulifyCurrentInfo();
                              homeViewModel.fecharInfos();
                              homeViewModel.getInfoI(results[i].title);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IngredientInfo(bgs),
                                ),
                              );
                            } else if (results[i] is Efeitos) {
                              homeViewModel.changeItem2(results[i]);
                              homeViewModel.updateRecentes(results[i], true);
                              homeViewModel.nulifyCurrentInfo2();
                              homeViewModel.getInfoE(results[i].title);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EffectInfo(bgs),
                                ),
                              );
                            }
                          },
                        ),
            ),
          );
  }
}
